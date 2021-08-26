require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TextProxy < WidgetProxy
      attr_reader :text

      def text=(value)
        @text = value
        Document.find(path).value = value
      end
      
      def element
        'input'
      end
      
      def observation_request_to_event_mapping
        {
          'on_modify_text' => {
            event: 'keyup',
            event_handler: -> (event_listener) {
              -> (event) {
                # TODO consider unifying this event handler with on_key_pressed by relying on its result instead of hooking another keyup event
                # TODO add all attributes for on_modify_text modify event
                if @last_key_pressed_event.nil? || @last_key_pressed_event.doit
                  @text = event.target.value
                  event_listener.call(event)
                else
                  # TODO Fix doit false, it's not stopping input
                  event.prevent
                  event.prevent_default
                  event.stop_propagation
                  event.stop_immediate_propagation
                end
              }
            }
          },
        }
      end
      
      def dom
        text_text = @text
        text_id = id
        text_style = css
        text_class = name
        options = {type: 'text', id: text_id, style: text_style, class: text_class, value: text_text, style: 'min-width: 27px;'}
        options = options.merge('disabled': 'disabled') unless @enabled
        options = options.merge(type: 'password') if has_style?(:password)
        @dom ||= html {
          input(options)
        }.to_s
      end
    end
  end
end
