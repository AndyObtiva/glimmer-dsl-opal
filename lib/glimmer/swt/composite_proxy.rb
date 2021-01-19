require 'glimmer/swt/grid_layout_proxy'
require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class CompositeProxy < WidgetProxy
      def initialize(parent, args, block)
        super(parent, args, block)
        @layout = default_layout
      end
      
      def default_layout
        GridLayoutProxy.new(self, [])
      end
      
      def dom
        div_id = id
        div_style = css
        div_class = name
        @dom ||= html {
          div(id: div_id, class: div_class, style: div_style)
        }.to_s
      end
      
      def layout=(the_layout)
        @layout = the_layout
      end
      alias set_layout layout=
      alias setLayout layout=
      
      def get_layout
        @layout
      end
      alias getLayout get_layout #TODO consider pregenerating these aliases with an easy method in the future

      def pack(*args)
        # No Op (just a shim) TODO consider if it should be implemented
      end
      
      def layout​(changed = nil, all = nil)
        # TODO implement layout(changed = nil, all = nil) just as per SWT API
        @layout&.layout(self, changed)
      end
            
    end
    
    CanvasProxy = CompositeProxy # TODO implement fully eventually
    
  end
  
end
