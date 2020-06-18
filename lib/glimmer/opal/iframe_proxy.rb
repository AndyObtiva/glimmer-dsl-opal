require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class IframeProxy < ElementProxy
      attr_reader :url
      
      def url=(value)
        @url = value
        redraw
      end
    
      def dom
        iframe_id = id
        iframe_url = url
        @dom ||= DOM {
          iframe(src: iframe_url, frameBorder: 0) {
          }
        }
      end      
    end
  end
end
