require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class LabelProxy < WidgetProxy
      attr_reader :text

      def text=(value)
        @text = value
        redraw
      end
      
      def path
        "#{parent_path} > label##{id}.#{name}"
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
    end
  end
end
