require 'glimmer/swt/layout_proxy'

module Glimmer
  module SWT
    class FillLayoutProxy < LayoutProxy
      attr_reader :type, :margin_width, :margin_height, :spacing
    
      def initialize(parent, args)
        super(parent, args)
        @type = @args.first || :horizontal
        @marign_width = 15
        @margin_height = 15
        reapply
      end

      def margin_width=(pixels)
        # TODO improve by using observers that reapply instead and/or add css class
        @margin_width = pixels
#         @parent.add_css_class("num-columns-#{@num_columns}")
        reapply
      end
      
      def margin_height=(pixels)
        @margin_height = pixels
#         @parent.add_css_class('make_columns_equal_width') if @make_columns_equal_width
        reapply
      end
      
      def spacing=(spacing)
        @spacing = spacing
#         @parent.add_css_class("horizontal-spacing-#{@horizontal_spacing}")
        reapply
      end
      
      def reapply
        if @type == :horizontal
          layout_css = <<~CSS
            display: flex;
            flex-direction: row;
          CSS
        elsif @type == :vertical
          layout_css = <<~CSS
            display: flex;
            flex-direction: column;
          CSS
        end
        layout_css.split(";").map(&:strip).map {|l| l.split(':').map(&:strip)}.each do |key, value|          
          @parent.dom_element.css(key, value) unless key.nil?
        end      
      end
      
    end
  end
end
