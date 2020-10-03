require 'glimmer/swt/layout_proxy'

module Glimmer
  module SWT
    class GridLayoutProxy < LayoutProxy
      attr_reader :num_columns, :make_columns_equal_width, :horizontal_spacing, :vertical_spacing
    
      def initialize(parent, args)
        super(parent, args)
        self.horizontal_spacing = 10
        self.vertical_spacing = 10
        self.num_columns = @args.first || 1        
        reapply
      end

      def num_columns=(columns)
        @num_columns = columns
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
      
      def reapply
        layout_css = <<~CSS
          display: grid;
          grid-template-columns: #{'auto ' * @num_columns.to_i};
          grid-row-gap: #{@vertical_spacing}px;
          grid-column-gap: #{@horizontal_spacing}px;
          justify-content: start;
        CSS
        layout_css.split(";").map(&:strip).map {|l| l.split(':').map(&:strip)}.each do |key, value|          
          @parent.dom_element.css(key, value) unless key.nil?
        end      
      end
    end
  end
end
