require 'glimmer/swt/property_owner'

module Glimmer
  module SWT
    class LayoutDataProxy
      include Glimmer::SWT::PropertyOwner
      attr_reader :parent, 
                  :args, 
                  :horizontal_alignment, 
                  :vertical_alignment, 
                  :grab_excess_horizontal_space,
                  :grab_excess_vertical_space,
                  :height_hint
    
      def initialize(parent, args)
        @parent = parent
        @args = args
        reapply
      end

      def height_hint=(height_hint)
        @height_hint = height_hint
        reapply
      end

      def horizontal_alignment=(horizontal_alignment)
        @horizontal_alignment = horizontal_alignment
        reapply
      end
      
      def vertical_alignment=(vertical_alignment)
        @vertical_alignment = vertical_alignment
        reapply
      end
      
      def grab_excess_horizontal_space=(grab_excess_horizontal_space)
        @grab_excess_horizontal_space = grab_excess_horizontal_space
        reapply
      end

      def grab_excess_vertical_space=(grab_excess_vertical_space)
        @grab_excess_vertical_space = grab_excess_vertical_space
        reapply
      end

      def reapply
#         @parent.css = <<~CSS
#         CSS
      end
    end
  end
end
