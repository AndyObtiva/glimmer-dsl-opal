require 'glimmer/swt/layout_proxy'

module Glimmer
  module SWT
    class GridLayoutProxy < LayoutProxy
      attr_reader :num_columns, :make_columns_equal_width, :horizontal_spacing, :vertical_spacing
    
      def initialize(parent, args)
        super(parent, args)
        @horizontal_spacing = 10
        @vertical_spacing = 10
        @num_columns = @args.first || 1        
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
    end
  end
end
