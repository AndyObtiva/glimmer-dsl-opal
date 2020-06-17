require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class DocumentProxy < ElementProxy
      # TODO consider renaming to ShellProxy to match SWT API
    
      def initialize(args)
        @args = args
        @children = []
        $document.ready do
          $document.head.replace(head_dom)
          $document.body.replace(dom)
        end
      end      

      def text
        $document.title
      end

      def text=(value)
        $document.title = value
      end

      def head_dom
        @head_dom ||= DOM {
          head {
            <<~CSS
            <style>
              div.grid_layout > * {
                display: block;
                margin-bottom: 10px;
              }
            </style>
            CSS
          }
        }
      end

      def dom
        @dom ||= DOM {
          body {
          }
        }
      end
      
      def open
        # No Op (just a placeholder since it is not needed on the web)
      end
    end
  end
end
