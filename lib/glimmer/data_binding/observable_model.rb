require 'glimmer/data_binding/observable'
require 'glimmer/data_binding/observer'

module Glimmer
  module DataBinding
    # TODO prefix utility methods with double-underscore
    module ObservableModel
      include Observable

      class Notifier
        include Glimmer::DataBinding::Observer
        def initialize(observable_model, property_name)
          @observable_model = observable_model
          @property_name = property_name
        end
        def call(new_value=nil)
          puts 'notify observers inside Notifier'
          @observable_model.notify_observers(@property_name)
        end
      end

      def add_observer(observer, property_name)
        return observer if has_observer?(observer, property_name)
        property_observer_list(property_name) << observer
        add_property_writer_observers(property_name)
        observer
      end

      def remove_observer(observer, property_name)
        property_observer_list(property_name).delete(observer)
      end

      def has_observer?(observer, property_name)
        property_observer_list(property_name).include?(observer)
      end

      def has_observer_for_any_property?(observer)
        property_observer_hash.values.map(&:to_a).sum.include?(observer)
      end

      def property_observer_hash
        @property_observers ||= Hash.new
      end

      def property_observer_list(property_name)
        property_observer_hash[property_name.to_sym] = Set.new unless property_observer_hash[property_name.to_sym]
        property_observer_hash[property_name.to_sym]
      end

      def notify_observers(property_name)
        property_observer_list(property_name).each {|observer| observer.call(send(property_name))}
      end
      #TODO upon updating values, make sure dependent observers are cleared (not added as dependents here)

      def add_property_writer_observers(property_name)
        property_writer_name = "#{property_name}="
        puts property_writer_name
        m = method(property_writer_name)
        puts 'method'
        puts m
        ensure_array_object_observer(property_name, send(property_name))
        puts 'done ensuring'
        begin
          method("__original_#{property_writer_name}")
        rescue
          # TODO consider alias_method or define_method instead
          puts 'rescue'
          i = 0          
          puts i+= 1
          puts 'property_writer_name'
          puts property_writer_name
          puts old_method = self.class.instance_method(property_writer_name)
          self.class.send(:define_method, "__original_#{property_writer_name}", old_method) 
          self.class.send(:define_method, property_writer_name) do |value|
            puts 'setting'
            old_value = self.send(property_name)
            unregister_dependent_observers(property_name, old_value)
            puts 'will call'
            self.send("__original_#{property_writer_name}", value)
            notify_observers(property_name)
            ensure_array_object_observer(property_name, value, old_value)
          end
          
#           instance_eval "alias __original_#{property_writer_name} #{property_writer_name}"
          puts i+= 1
#           instance_eval <<-end_eval, __FILE__, __LINE__
#           def #{property_writer_name}(value)
#             old_value = self.#{property_name}
#             unregister_dependent_observers('#{property_name}', old_value)
#             self.__original_#{property_writer_name}(value)
#             notify_observers('#{property_name}')
#             ensure_array_object_observer('#{property_name}', value, old_value)
#           end
#           end_eval
          puts i+= 1
        end
      rescue => e
        puts 'error'
        puts e.message
        # ignore writing if no property writer exists
        Glimmer::Config.logger&.debug "No need to observe property writer: #{property_writer_name}\n#{e.message}\n#{e.backtrace.join("\n")}"
      end

      def unregister_dependent_observers(property_name, old_value)
        # TODO look into optimizing this
        return unless old_value.is_a?(ObservableModel) || old_value.is_a?(ObservableArray)
        property_observer_list(property_name).each do |observer|
          observer.unregister_dependents_with_observable(observer.registration_for(self, property_name), old_value)
        end
      end

      def ensure_array_object_observer(property_name, object, old_object = nil)
        i = 0
        puts 'ensure_array_object_observer'
        puts i += 1
        puts object.inspect
        return unless object.is_a?(Array)
        puts i += 1
        array_object_observer = array_object_observer_for(property_name)
        puts i += 1
        puts array_object_observer.inspect
        array_observer_registration = array_object_observer.observe(object)
        puts i += 1
        property_observer_list(property_name).each do |observer|
          my_registration = observer.registration_for(self, property_name) # TODO eliminate repetition
          observer.add_dependent(my_registration => array_observer_registration)
        end
        puts i += 1
        array_object_observer_for(property_name).unregister(old_object) if old_object.is_a?(ObservableArray)
      end

      def array_object_observer_for(property_name)
        @array_object_observers ||= {}
        unless @array_object_observers.has_key?(property_name)
          @array_object_observers[property_name] = ObservableModel::Notifier.new(self, property_name)
        end
        @array_object_observers[property_name]
      end
    end
  end
end
