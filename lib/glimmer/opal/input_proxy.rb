
module Glimmer
  module Opal
    class InputProxy
      attr_reader :text
      
      OBSERVATION_REQUEST_MAPPING = {
        InputProxy => {
          'on_widget_selected' => 'click'
        }
      }
      
      def initialize(parent, args)
        @parent = parent
        @args = args
        @parent.add_child(self)
      end
      
      def text=(value)
        @text = value
        redraw
      end

      def redraw
        old_dom = @dom
        @dom = nil
        old_dom.replace dom
      end

      def handle_observation_request(keyword, &block)
        event = OBSERVATION_REQUEST_MAPPING[self.class][keyword]
        selector = 'input'        
        delegate = $document.on(event, selector) do |event|
          block.call(event)
        end
        EventListenerProxy.new(element_proxy: self, event: event, selector: selector, delegate: delegate)
      end

      def dom
        input_text = @text
        @dom ||= DOM {
          input type: 'button', value: input_text
        }
      end
    end
  end
end
