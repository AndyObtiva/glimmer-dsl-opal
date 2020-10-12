require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class LabelProxy < WidgetProxy
      attr_reader :text

      def text=(value)
        @text = value
        dom_element.html(value)
      end
      
      def element
        'label'
      end
      
      def alignment
        [:left, :center, :right].detect {|value| args.detect { |arg| SWTProxy[value] == arg } }
      end
      
      def dom        
        label_text = @text
        label_id = id
        label_style = "text-align: #{alignment};"
        label_class = name
        @dom ||= html {
          label(id: label_id, style: label_style, class: label_class) {
            label_text
          }
        }.to_s
      end
    end
  end
end
