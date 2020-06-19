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
                @text = event.target.value
                event_listener.call(event)              
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
        @dom ||= DOM {
          input input_args.merge(id: input_id, style: input_style, value: input_text)
        }
      end
    end
  end
end
