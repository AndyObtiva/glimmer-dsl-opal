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
          }
        }
      end
      
      def dom
        input_text = @text
        input_id = id
        @dom ||= DOM {
          input id: input_id, type: 'button', value: input_text
        }
      end
    end
  end
end
