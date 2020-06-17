module Glimmer
  module Opal
    class ElementProxy
      attr_reader :parent, :args
      
      def initialize(parent, args)
        @parent = parent
        @args = args
        @children = []
        @parent.add_child(self)
      end

      def add_child(child)
        return if @children.include?(child)
        @children << child
        dom << child.dom
      end

      def redraw
        old_dom = @dom
        @dom = nil
        old_dom.replace dom
      end
      
      # Subclasses must override with their own mappings
      def observation_request_to_event_mapping
        {}
      end
      
      def name
        self.class.name.split('::').last.underscore.sub(/_proxy$/, '')
      end
      
      def id
        "#{name}-#{hash}"
      end
      
      # Subclasses can override with their own selector
      def selector
        "#{name}##{id}"
      end
      
      def handle_observation_request(keyword, &event_listener)
        event = observation_request_to_event_mapping[keyword][:event]
        event_handler = observation_request_to_event_mapping[keyword][:event_handler]
        event_listener = event_handler&.call(event_listener) || event_listener
        delegate = $document.on(event, selector, &event_listener)
        EventListenerProxy.new(element_proxy: self, event: event, selector: selector, delegate: delegate)
      end         
    end
  end
end
