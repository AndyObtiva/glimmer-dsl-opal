require 'glimmer/swt/grid_layout_proxy'
require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class CompositeProxy < WidgetProxy
      attr_reader :layout
      
      def initialize(parent, args)
        super(parent, args)
        @layout = GridLayoutProxy.new(self, [])
      end
      
      def redraw
        super()
        @children.each do |child|
          add_child(child) # TODO think of impact of this on performance, and of other alternatives
        end
      end
      
      def dom
        div_id = id
        div_style = css
        div_class = "#{name} grid-layout"
        @dom ||= html {
          div(id: div_id, class: div_class, style: div_style)
        }
      end
    end
  end
end
