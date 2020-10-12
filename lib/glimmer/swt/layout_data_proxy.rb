require 'glimmer/swt/property_owner'

module Glimmer
  module SWT
    class LayoutDataProxy
      include Glimmer::SWT::PropertyOwner
      attr_reader :parent, 
                  :args, 
                  :horizontal_alignment, 
                  :vertical_alignment, 
                  :horizontal_span, 
                  :vertical_span, 
                  :horizontal_indent, 
                  :vertical_indent, 
                  :grab_excess_horizontal_space,
                  :grab_excess_vertical_space,
                  :height_hint
    
      def initialize(parent, args)
        @parent = parent
        @args = args
        # TODO spread args correctly
        # TODO avoid using reapply
        reapply
      end

      def height_hint=(height_hint)
        @height_hint = height_hint
        # TODO
        reapply
      end

      def horizontal_alignment=(horizontal_alignment)
        @horizontal_alignment = horizontal_alignment
        # TODO
        reapply
      end
      
      def vertical_alignment=(vertical_alignment)
        @vertical_alignment = vertical_alignment
        # TODO
        reapply
      end
      
      def horizontal_span=(value)
        @horizontal_span = value
        @parent.dom_element.css('grid-column-start', "span #{@horizontal_span}")
        reapply
      end
      
      def vertical_span=(value)
        @vertical_span = value
        @parent.dom_element.css('grid-row-start', "span #{@horizontal_span}")
        reapply
      end
      
      def horizontal_indent=(value)
        @horizontal_indent = value
        @parent.dom_element.css('padding-left', @horizontal_indent)
        reapply
      end
      
      def vertical_indent=(value)
        @vertical_indent = value
        @parent.dom_element.css('padding-top', @vertical_indent)
        reapply
      end
      
      def grab_excess_horizontal_space=(grab_excess_horizontal_space)
        @grab_excess_horizontal_space = grab_excess_horizontal_space
        # TODO
        reapply
      end

      def grab_excess_vertical_space=(grab_excess_vertical_space)
        @grab_excess_vertical_space = grab_excess_vertical_space
        # TODO
        reapply
      end

      def reapply
#         @parent.css = <<~CSS
#         CSS
      end
    end
  end
end
