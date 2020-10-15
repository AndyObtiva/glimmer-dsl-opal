require 'glimmer/swt/layout_proxy'

module Glimmer
  module SWT
    class RowLayoutProxy < LayoutProxy
      include Glimmer
      
      STYLE = <<~CSS
        .row-layout {
          display: flex;
        }
                
        .row-layout-pack {
          display: initial;
        }
                
        .row-layout-horizontal {
          flex-direction: row;
        }
        
        .row-layout-horizontal.row-layout-pack {
          flex-direction: none;
        }
        
        .row-layout-vertical {
          flex-direction: column;
        }
        
        .row-layout-vertical.row-layout-pack {
          flex-direction: none;          
        }
      CSS
    
      attr_reader :type, :margin_width, :margin_height, :spacing, :pack
    
      def initialize(parent, args)
        super(parent, args)
        @type = @args.first || :horizontal
        @marign_width = 15
        @margin_height = 15
        self.pack = true
        @parent.dom_element.add_class('row-layout')
        @parent.dom_element.add_class(horizontal? ? 'row-layout-horizontal' : 'row-layout-vertical')
      end
      
      def horizontal?
        @type == :horizontal
      end

      def vertical?
        @type == :vertical
      end
      
      def dom(widget_dom)        
        dom_result = widget_dom
        dom_result += '<br />' if vertical? && @pack
        dom_result
      end

      def pack=(value)
        @pack = value
        if @pack
          @parent.dom_element.add_class('row-layout-pack')
        else
          @parent.dom_element.remove_class('row-layout-pack')
        end
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
      
      def spacing=(spacing)
        @spacing = spacing.to_i
        # TODO implement changes to accomodate layout_data in the future
        @parent.style_element.html css {
          s("##{@parent.id} > *") {
            if horizontal?
              margin_right "#{@spacing}px"
            elsif vertical?
              margin_bottom "#{@spacing}px"
            end
          }          
          s("##{@parent.id} > :last-child") {
            if horizontal?
              margin_right 0
            elsif vertical?
              margin_bottom 0
            end
          }
        }.to_s
      end
      
    end
  end
end
