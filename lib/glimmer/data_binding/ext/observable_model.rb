require 'glimmer/data_binding/observable'
require 'glimmer/data_binding/observer'
require 'glimmer/opal/display_proxy'

# This ensures all data-binding events happen async and block on modal display

module Glimmer
  module DataBinding
    # TODO prefix utility methods with double-underscore
    module ObservableModel
      include Observable
#       include Glimmer

      def add_property_writer_observers(property_name)
        property_writer_name = "#{property_name}="
        method(property_writer_name)
        ensure_array_object_observer(property_name, send(property_name))
        begin
          method("__original_#{property_writer_name}")
        rescue
          old_method = self.class.instance_method(property_writer_name)
          define_singleton_method("__original_#{property_writer_name}", old_method)
          define_singleton_method(property_writer_name) do |value|
            old_value = self.send(property_name)
            unregister_dependent_observers(property_name, old_value)
            self.send("__original_#{property_writer_name}", value)
#             Glimmer::Opal::DisplayProxy.instance.async_exec do
            notify_observers(property_name)
            ensure_array_object_observer(property_name, value, old_value)
#             end
          end
        end
      rescue => e
        # ignore writing if no property writer exists
        Glimmer::Config.logger&.debug "No need to observe property writer: #{property_writer_name}\n#{e.message}\n#{e.backtrace.join("\n")}"
      end
      
    end
  end
end
