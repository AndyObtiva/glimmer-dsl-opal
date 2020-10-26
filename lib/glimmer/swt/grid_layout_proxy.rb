require 'glimmer/swt/layout_proxy'

module Glimmer
  module SWT
    class GridLayoutProxy < LayoutProxy
      STYLE = <<~CSS
        .grid-layout {
          display: grid;
          grid-template-rows: min-content;
          justify-content: start;
          place-content: start;
          align-items: stretch;      
        }
      CSS
      attr_reader :num_columns, :make_columns_equal_width, :horizontal_spacing, :vertical_spacing, :margin_width, :margin_height
    
      def initialize(parent, args)
        super(parent, args)
        self.horizontal_spacing = 10
        self.vertical_spacing = 10
        self.num_columns = @args.first || 1        
        reapply
      end

      def num_columns=(columns)
        @num_columns = columns
        # TODO do the following instead of reapply
#         @parent.add_css_class("num-columns-#{@num_columns}")
        reapply
      end
      
      def make_columns_equal_width=(equal_width)
        @make_columns_equal_width = equal_width        
#         @parent.add_css_class('make_columns_equal_width') if @make_columns_equal_width
        reapply
      end
      
      def horizontal_spacing=(spacing)
        @horizontal_spacing = spacing
#         @parent.add_css_class("horizontal-spacing-#{@horizontal_spacing}")
        reapply
      end

      def vertical_spacing=(spacing)
        @vertical_spacing = spacing
#         @parent.add_css_class("vertical-spacing-#{@vertical_spacing}")
        reapply
      end
      
      def margin_width=(pixels)
        @margin_width = pixels
        # Using padding for width since margin-right isn't getting respected with width 100%
        @parent.dom_element.css('padding-left', @margin_width)
        @parent.dom_element.css('padding-right', @margin_width)
      end
      
      def margin_height=(pixels)
        @margin_height = pixels
        @parent.dom_element.css('padding-top', @margin_height)
        @parent.dom_element.css('padding-bottom', @margin_height)
      end
            
      def reapply
        # TODO get rid of this method
        layout_css = <<~CSS
          grid-template-columns: #{'auto ' * @num_columns.to_i};
          grid-row-gap: #{@vertical_spacing}px;
          grid-column-gap: #{@horizontal_spacing}px;
        CSS
        if @parent.css_classes.include?('grid-layout')
          layout_css.split(";").map(&:strip).map {|l| l.split(':').map(&:strip)}.each do |key, value|          
            @parent.dom_element.css(key, value) unless key.nil?
          end
        else
          layout_css.split(";").map(&:strip).map {|l| l.split(':').map(&:strip)}.each do |key, value|          
            @parent.dom_element.css(key, 'initial') unless key.nil?
          end        
        end
      end      
    end
  end
end
