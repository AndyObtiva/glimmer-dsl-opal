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
        $document.ready do
          $document.title = value
        end
      end

      def head_dom
        # TODO make grid-layout support grab excess space false
        @head_dom ||= DOM {
          head {
#             <<~CSS
#             <style>
#               div.grid-layout {
#                 display: grid;
#                 grid-template-columns: auto;
#                 grid-row-gap: 10px;
#                 justify-content: start;
#               }
#             </style>
#             CSS
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
