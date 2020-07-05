require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TextProxy < WidgetProxy
      attr_reader :text

      def text=(value)
        @text = value
        Document.find(path)&.value = value
      end
      
      def element
        'input'
      end
      
      def dom
        text_text = @text
        text_id = id
        text_style = css
        text_class = name
        @dom ||= html {
          input(type: 'text', id: text_id, style: text_style, class: text_class, value: text_text)
        }.to_s
      end
    end
  end
end
