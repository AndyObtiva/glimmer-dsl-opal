module Glimmer
  module SWT
    class EventListenerProxy
      attr_reader :element_proxy, :event, :selector, :delegate

      def initialize(element_proxy:, event:, selector:, delegate:)
        @element_proxy = element_proxy
        @event = event
        @selector = selector
        @delegate = delegate
      end
      
      def unregister
        $document.off(@delegate)
      end
    end
  end
end
