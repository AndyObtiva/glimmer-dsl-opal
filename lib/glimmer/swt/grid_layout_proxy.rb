require 'glimmer/swt/layout_proxy'

module Glimmer
  module SWT
    class GridLayoutProxy < LayoutProxy
      STYLE = <<~CSS
        .grid-layout {
          display: grid;
          grid-template-rows: min-content;
          place-content: start;
          align-items: stretch;
        }
      CSS
      
      attr_reader :num_columns, :make_columns_equal_width, :horizontal_spacing, :vertical_spacing, :margin_width, :margin_height
    
      def num_columns=(columns)
        @num_columns = columns
        # TODO do the following instead of reapply
#         @parent.add_css_class("num-columns-#{@num_columns}")
        # reinitialize # TODO reimplement without using reinitialize
        layout_css = <<~CSS
          grid-template-columns: #{'auto ' * @num_columns.to_i};
          grid-row-gap: #{@vertical_spacing}px;
          grid-column-gap: #{@horizontal_spacing}px;
        CSS
        if @parent.css_classes.include?('grid-layout')
          layout_css.split(";").map(&:strip).map {|l| l.split(':').map(&:strip)}.each do |key, value|
            @parent.dom_element.css(key, value) unless key.nil?
          end
          if @parent.is_a?(GroupProxy)
            @parent.dom_element.find('legend').css('grid-column-start', "span #{@num_columns.to_i}")
          end
        else
          layout_css.split(";").map(&:strip).map {|l| l.split(':').map(&:strip)}.each do |key, value|
            @parent.dom_element.css(key, 'initial') unless key.nil?
          end
        end
      end
      
      def make_columns_equal_width=(equal_width)
        @make_columns_equal_width = equal_width
#         @parent.add_css_class('make_columns_equal_width') if @make_columns_equal_width
        # reinitialize # TODO reimplement without using reinitialize
      end
      
      def horizontal_spacing=(spacing)
        @horizontal_spacing = spacing
#         @parent.add_css_class("horizontal-spacing-#{@horizontal_spacing}")
        # reinitialize # TODO reimplement without using reinitialize
      end

      def vertical_spacing=(spacing)
        @vertical_spacing = spacing
#         @parent.add_css_class("vertical-spacing-#{@vertical_spacing}")
        # reinitialize # TODO reimplement without using reinitialize
      end
      
      def margin_width=(pixels)
        @margin_width = pixels
        # Using padding for width since margin-right isn't getting respected with width 100%
        effective_margin_width = @margin_width
        effective_margin_width += 6 if @parent.is_a?(GroupProxy)
        @parent.dom_element.css('padding-left', effective_margin_width)
        @parent.dom_element.css('padding-right', effective_margin_width)
      end
      
      def margin_height=(pixels)
        @margin_height = pixels
        effective_margin_height = @margin_height
        effective_margin_height += 9 if @parent.is_a?(GroupProxy)
        @parent.dom_element.css('padding-top', effective_margin_height)
        @parent.dom_element.css('padding-bottom', effective_margin_height)
      end
            
      def initialize(parent, args)
        super(parent, args)
        self.horizontal_spacing = 10
        self.vertical_spacing = 10
        self.margin_width = 15
        self.margin_height = 15
        self.num_columns = @args.first || 1
      end
    end
  end
end
