require 'glimmer/swt/composite_proxy'
require 'glimmer/swt/color_proxy'

module Glimmer
  module SWT
    class SashFormProxy < CompositeProxy
      STYLE = <<~CSS
        .sash-form {
          position: relative;
        }
      CSS
      attr_reader :orientation, :sash_width, :weights, :maximized_control, :background
      
      def initialize(parent, args, block)
        vertical = args.detect { |arg| SWTProxy[:vertical] == SWTProxy[arg] }
        @orientation = vertical ? 'vertical' : 'horizontal'
        @sash_width = 5
        @background = ColorProxy.new(230, 230, 230).to_css
        @ratio = 0.5
        super(parent, args, block)
      end
      
      # assumes 2 children
      def post_add_content
        @child1 = dom_element.children.eq(0)
        @child2 = dom_element.children.eq(1)
        unless @child1.empty? || @child2.empty?
          dom_element.sash(content1: "##{@child1.attr('id')}", content2: "##{@child2.attr('id')}", splitterColor: @background, orientation: @orientation, ratio: @ratio, width1: dom_element.outerWidth * @ratio, width2: dom_element.outerWidth * (1.0/@ratio))
#           dom_element.sash('splitterWidth', @sash_width) # does not work TODO support in the future by amending javascript
#           dom_element.sash('splitterColor', @background) # does not work TODO support in the future by amending javascript
          if orientation == 'vertical'
            sash_splitter_dom_element.css('height', @sash_width)
          else
            sash_splitter_dom_element.css('width', @sash_width)
          end
          dom_element.on('sashDragged') do |event|
            self.sash_width = @sash_width # reset sash width
          end
          @initialized = true
        end
      end
      
      def orientation=(value)
        vertical = SWTProxy[:vertical] == SWTProxy[value]
        @orientation = vertical ? 'vertical' : 'horizontal'
        dom_element.sash('orientation', @orientation) if @initialized
        self.sash_width = @sash_width # re-initialize depending on new orientation
      end
      
      def sash_width=(value)
        @sash_width = value.to_i
        if @initialized
          if orientation == 'vertical'
            sash_splitter_dom_element.css('height', @sash_width)
          else
            sash_splitter_dom_element.css('width', @sash_width)
          end
        end
      end
      
      # sets weights (in ratio to each other), assuming 2
      def weights=(*weights_array)
        @weights = weights_array
        @ratio = @weights.first.to_f / (@weights.first + @weights.last).to_f
        dom_element.sash('ratio', @ratio) if @initialized
      end
      
      def maximized_control=(control)
        return unless @initialized
        if control.nil?
          dom_element.sash('visible1', true)
          dom_element.sash('visible2', true)
        elsif control.dom_element.attr('id') == @child1.attr('id')
          dom_element.sash('visible1', true)
          dom_element.sash('visible2', false)
        elsif control.dom_element.attr('id') == @child2.attr('id')
          dom_element.sash('visible1', false)
          dom_element.sash('visible2', true)
        end
      end
      
      def background=(value)
        @background = value.is_a?(ColorProxy) ? value.to_css : value
#         dom_element.sash('splitterColor', @background) if @initialized # does not work TODO support in the future by amending javascript
      end
      
      def element
        'div'
      end
      
      def sash_splitter_path
        "#{path} .sashSplitter"
      end
      
      def sash_splitter_dom_element
        Document.find(sash_splitter_path)
      end
      
      def dom
        sash_form_text = @text
        sash_form_id = id
        sash_form_class = name
        options = {id: sash_form_id, class: sash_form_class}
        @dom ||= html {
          div(options)
        }.to_s
      end
    end
  end
end
