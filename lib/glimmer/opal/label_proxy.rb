require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class LabelProxy < ElementProxy
      attr_reader :text

      def text=(value)
        @text = value
        redraw
      end

      def dom
        label_text = @text
        label_id = id
        label_style = style
        @dom ||= DOM {
          label(id: label_id, style: label_style) {
            label_text
          }
        }
      end
    end
  end
end
