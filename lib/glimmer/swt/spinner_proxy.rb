require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class SpinnerProxy < WidgetProxy
      attr_reader :selection
    
      def initialize(parent, args, block)
        super(parent, args, block)
        dom_element.spinner
      end

      def selection=(value)
        @selection = value
        dom_element.value = value
      end
      
      def text=(value)
        self.selection = value.to_f
      end
      
      def text
        self.selection.to_s
      end
      
      def element
        'input'
      end
      
      def observation_request_to_event_mapping
        {
          'on_widget_selected' => [
            {
              event: 'change',
              event_handler: -> (event_listener) {
                -> (event) {
                  self.selection = event.target.value
                  event_listener.call(event)
                }
              }
            },
            {
              event: 'spinstop',
              event_handler: -> (event_listener) {
                -> (event) {
                  self.selection = event.target.value
                  event_listener.call(event)
                }
              }
            },
          ],
          'on_modify_text' => {
            event: 'keyup',
            event_handler: -> (event_listener) {
              -> (event) {
                # TODO consider unifying this event handler with on_key_pressed by relying on its result instead of hooking another keyup event
                if @last_key_pressed_event.nil? || @last_key_pressed_event.doit
                  self.text = event.target.value
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
          'on_key_pressed' => {
            event: 'keydown',
            event_handler: -> (event_listener) {
              -> (event) {
                @last_key_pressed_event = event
                self.text = event.target.value
                # TODO generalize this solution to all widgets that support key presses
                # TODO support event.location once DOM3 is supported by opal-jquery
                event.define_singleton_method(:keyCode) {event.which}
                event.define_singleton_method(:key_code, &event.method(:keyCode))
                event.define_singleton_method(:character) {event.which.chr}
                event.define_singleton_method(:stateMask) do
                  state_mask = 0
                  state_mask |= SWTProxy[:alt] if event.alt_key
                  state_mask |= SWTProxy[:ctrl] if event.ctrl_key
                  state_mask |= SWTProxy[:shift] if event.shift_key
                  state_mask |= SWTProxy[:command] if event.meta_key
                  state_mask
                end
                event.define_singleton_method(:state_mask, &event.method(:stateMask))
                doit = true
                event.define_singleton_method(:doit=) do |value|
                  doit = value
                end
                event.define_singleton_method(:doit) { doit }
                event_listener.call(event)
                
                  # TODO Fix doit false, it's not stopping input
                unless doit
                  event.prevent
                  event.prevent_default
                  event.stop_propagation
                  event.stop_immediate_propagation
                end
                
                doit
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
        # TODO support password field
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
