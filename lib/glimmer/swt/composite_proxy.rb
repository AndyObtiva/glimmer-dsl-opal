require 'glimmer/swt/grid_layout_proxy'
require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class CompositeProxy < WidgetProxy
      attr_reader :layout
      
      def initialize(parent, args, block)
        super(parent, args, block)
        @layout = GridLayoutProxy.new(self, [])
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
      
    end
    
  end
  
end
