module Glimmer
  module SWT
    class LatestShellProxy #< ShellProxy
      # TODO consider overriding all methods from ShellProxy and proxying to them
      
      def initialize(parent, args, block)
        # No Op
      end
      
      def open
        Document.ready? do
          DisplayProxy.instance.shells.last&.open
        end
      end

    end
    
  end
  
end
