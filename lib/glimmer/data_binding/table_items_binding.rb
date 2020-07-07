require 'glimmer/data_binding/observable_array'
require 'glimmer/data_binding/observable_model'
require 'glimmer/data_binding/observable'
require 'glimmer/data_binding/observer'
require 'glimmer/swt/table_proxy'
require 'glimmer/swt/table_item_proxy'

module Glimmer
  module DataBinding
    class TableItemsBinding
      include DataBinding::Observable
      include DataBinding::Observer

      def initialize(parent, model_binding, column_properties)
        @last_model_collection = nil
        @table = parent
        @model_binding = model_binding
        @column_properties = column_properties
        if @table.respond_to?(:column_properties=)
          @table.column_properties = @column_properties
        ##else # assume custom widget
        ##  @table.body_root.column_properties = @column_properties
        end
        call(@model_binding.evaluate_property)
        model = model_binding.base_model
        observe(model, model_binding.property_name_expression)
        ##@table.on_widget_disposed do |dispose_event| # doesn't seem needed within Opal
        ##  unregister_all_observables
        ##end
      end

      def call(new_model_collection=nil)
        if new_model_collection and new_model_collection.is_a?(Array)
          observe(new_model_collection, @column_properties)
          @model_collection = new_model_collection
        end
        populate_table(@model_collection, @table, @column_properties)
        sort_table(@model_collection, @table, @column_properties)
      end
      
      def populate_table(model_collection, parent, column_properties)
        return if model_collection&.sort_by(&:hash) == @last_model_collection&.sort_by(&:hash)
        @last_model_collection = model_collection
        # TODO improve performance
        selected_table_item_models = parent.selection.map(&:get_data)
        old_items = parent.items
        old_item_ids_per_model = old_items.reduce({}) {|hash, item| hash.merge(item.get_data.hash => item.id) }
        parent.remove_all
        model_collection.each do |model|
          table_item = Glimmer::SWT::TableItem.new(parent)
          for index in 0..(column_properties.size-1)
            table_item.set_text(index, model.send(column_properties[index]).to_s)
          end
          table_item.set_data(model)
          table_item.id = old_item_ids_per_model[model.hash] if old_item_ids_per_model[model.hash]
        end
        selected_table_items = parent.search {|item| selected_table_item_models.include?(item.get_data) }
        selected_table_items = [parent.items.first] if selected_table_items.empty? && !parent.items.empty?
        parent.selection = selected_table_items unless selected_table_items.empty?
        parent.redraw
      end
      
      def sort_table(model_collection, parent, column_properties)
        return if model_collection == @last_model_collection
        parent.items = parent.items.sort_by { |item| model_collection.index(item.get_data) }
        @last_model_collection = model_collection
      end      
    end
  end
end
