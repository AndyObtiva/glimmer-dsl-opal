module Glimmer
  module Opal
    class DivProxy
      def initialize(parent, args)
        @parent = parent
        @args = args
        @parent.add_child(self)
        @children = []
      end

      def add_child(child)
        return if @children.include?(child)
        @children << child
        dom << child.dom
      end

      def redraw
        old_dom = @dom
        @dom = nil
        old_dom.replace dom
      end

      def dom
        label_text = @text
        @dom ||= DOM {
          div
        }
      end
    end
  end
end
