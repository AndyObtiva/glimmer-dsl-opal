require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class LabelProxy < WidgetProxy
      attr_reader :text

      def text=(value)
        @text = value
        redraw
      end
      
      def element
        'label'
      end
      
      def dom
        label_text = @text
        label_id = id
        label_style = css
        label_class = name
        @dom ||= html {
          label(id: label_id, style: label_style, class: label_class) {
            label_text
          }
        }.to_s
      end
      
      def redraw
        super
        the_element = Document.find(path)
        pd alignment = [:left, :center, :right].detect {|value| args.detect { |arg| SWTProxy[value] == arg } }
        the_element.css('text-align', alignment.to_s)
      end
    end
  end
end
