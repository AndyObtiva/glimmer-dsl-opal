require 'glimmer/swt/composite_proxy'

module Glimmer
  module SWT
    class CanvasProxy < CompositeProxy
      def element
        'svg'
      end
      
      def dom
        canvas_id = id
        canvas_class = name
        # TODO in the future, calculate width and height from children automatically (just like Glimmer DSL for SWT)
        @dom ||= html {
          svg(id: canvas_id, class: canvas_class, width: 9999999, height: 9999999) {
            'Sorry, your browser does not support inline SVG.'
          }
        }.to_s
      end
    
    end
  end
end
