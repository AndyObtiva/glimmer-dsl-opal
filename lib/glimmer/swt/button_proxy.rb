require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/radio_proxy'
require 'glimmer/swt/checkbox_proxy'

module Glimmer
  module SWT
    class ButtonProxy < WidgetProxy
      class << self
        def create(keyword, parent, args)
          if args.to_a.include?(:radio)
            RadioProxy.new(parent, args)
          elsif args.to_a.include?(:check)
            CheckboxProxy.new(parent, args)
          else
            new(parent, args)
          end
        end
      end
    
      attr_reader :text
      
      def text=(value)
        @text = value
        dom_element.html(@text)
      end
      
      def element
        'button'
      end

      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click'
          },
        }
      end
      
      def dom
        input_text = @text
        input_id = id
        input_style = css
        input_args = {}
        input_disabled = @enabled ? {} : {'disabled': 'disabled'}
        input_args = input_args.merge(type: 'password') if has_style?(:password)
        @dom ||= html {
          button(input_args.merge(id: input_id, class: name, style: input_style, style: 'min-width: 27px; min-height: 27px;').merge(input_disabled)) {
            input_text.to_s == '' ? '&nbsp;' : input_text
          }
        }.to_s
      end
    end
  end
end
