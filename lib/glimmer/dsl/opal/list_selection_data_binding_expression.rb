require 'glimmer/dsl/expression'
require 'glimmer/data_binding/model_binding'
require 'glimmer/data_binding/element_binding'
require 'glimmer/data_binding/list_selection_binding'
require 'glimmer/swt/list_proxy'

module Glimmer
  module DSL
    module Opal
      class ListSelectionDataBindingExpression < Expression
        def can_interpret?(parent, keyword, *args, &block)
          keyword == 'selection' and
            block.nil? and
            parent.is_a?(Glimmer::SWT::ListProxy) and
            args.size == 1 and
            args[0].is_a?(DataBinding::ModelBinding) and
            args[0].evaluate_options_property.is_a?(Array)
        end
  
        def interpret(parent, keyword, *args, &block)
          model_binding = args[0]
          element_binding = DataBinding::ElementBinding.new(parent, 'items')
          element_binding.call(model_binding.evaluate_options_property)
          model = model_binding.base_model
          #TODO make this options observer dependent and all similar observers in widget specific data binding interpretrs
          element_binding.observe(model, model_binding.options_property_name)
  
          property_type = :string
          property_type = :array if parent.has_style?(:multi)
          list_selection_binding = DataBinding::ListSelectionBinding.new(parent, property_type)
          list_selection_binding.call(model_binding.evaluate_property)
          #TODO check if nested data binding works for list widget and other widgets that need custom data binding
          list_selection_binding.observe(model, model_binding.property_name_expression)
          parent.on_widget_selected do
            model_binding.call(list_selection_binding.evaluate_property)
          end
        end
      end
    end
  end
end
