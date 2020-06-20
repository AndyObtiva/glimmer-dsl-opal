require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class InputProxy < ElementProxy
      attr_reader :text
      
      def text=(value)
        @text = value
        redraw
      end

      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click'
          }, 
          'on_modify_text' => {
            event: 'keyup',
            event_handler: -> (event_listener) {
              -> (event) {
                if args.last[:type] == 'text'
                  @text = event.target.value
                  event_listener.call(event)              
                end
              }
            }
          }
        }
      end
      
      def dom
        input_text = @text
        input_id = id
        input_style = css
        input_args = @args.last
        input_disabled = @enabled ? {} : {'disabled': 'disabled'}
        input_args = input_args.merge(type: 'password') if has_style?(:password)        
        @dom ||= DOM {
          input input_args.merge(id: input_id, style: input_style, value: input_text, style: 'min-width: 27px;').merge(input_disabled)
        }
      end
    end
  end
end
