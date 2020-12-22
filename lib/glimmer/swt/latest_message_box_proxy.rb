module Glimmer
  module SWT
    class LatestMessageBoxProxy #< MessageBoxProxy
      # TODO consider overriding all methods from MessageBoxProxy and proxying to them
      
      def initialize(parent, args, block)
        # No Op
      end
      
      def open
        Document.ready? do
          DisplayProxy.instance.message_boxes.last&.open
        end
      end

    end
    
  end
  
end
