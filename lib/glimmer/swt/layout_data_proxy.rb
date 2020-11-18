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
                  :width_hint,
                  :height_hint
    
      def initialize(parent, args)
        @parent = parent
        @args = args
        self.horizontal_alignment = @args[0] if @args[0]
        self.vertical_alignment = @args[1] if @args[1]
        self.grab_excess_horizontal_space = @args[2] if @args[2]
        self.grab_excess_vertical_space = @args[3] if @args[3]
        # TODO spread args correctly as per SWT LayoutData API
        # TODO avoid using reapply
#         reapply
      end

      def width_hint=(width_hint)
        @width_hint = width_hint
        @parent.dom_element.css('width', "#{@width_hint}px")
#         reapply
      end

      def height_hint=(height_hint)
        @height_hint = height_hint
        @parent.dom_element.css('height', "#{@height_hint}px")
#         reapply
      end

      def horizontal_alignment=(horizontal_alignment)
        @horizontal_alignment = horizontal_alignment
        return if @horizontal_alignment.nil?
        if @horizontal_alignment == 'fill'
          @parent.dom_element.css('width', '100%') if width_hint.nil?
        else
          @parent.dom_element.css('text-align', @horizontal_alignment)
        end
        # TODO
#         reapply
      end
      
      def vertical_alignment=(vertical_alignment)
        @vertical_alignment = vertical_alignment
        # TODO
#         reapply
      end
      
      def horizontal_span=(value)
        @horizontal_span = value
        @parent.dom_element.css('grid-column-start', "span #{@horizontal_span}")
#         reapply
      end
      
      def vertical_span=(value)
        @vertical_span = value
        @parent.dom_element.css('grid-row-start', "span #{@vertical_span}")
#         reapply
      end
      
      def horizontal_indent=(value)
        @horizontal_indent = value
        @parent.dom_element.css('padding-left', @horizontal_indent)
#         reapply
      end
      
      def vertical_indent=(value)
        @vertical_indent = value
        @parent.dom_element.css('padding-top', @vertical_indent)
#         reapply
      end
      
      def grab_excess_horizontal_space=(grab_excess_horizontal_space)
        @grab_excess_horizontal_space = grab_excess_horizontal_space
        @parent.dom_element.css('width', "100%") if @grab_excess_horizontal_space && width_hint.nil?
#         reapply
      end

      def grab_excess_vertical_space=(grab_excess_vertical_space)
        @grab_excess_vertical_space = grab_excess_vertical_space
        @parent.dom_element.css('height', "100%") if @grab_excess_vertical_space && height_hint.nil?
        # TODO
#         reapply
      end

      def reapply
#         @parent.css = <<~CSS
#         CSS
      end
    end
  end
end
