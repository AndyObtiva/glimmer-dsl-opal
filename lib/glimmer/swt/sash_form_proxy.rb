require 'glimmer/swt/composite_proxy'

module Glimmer
  module SWT
    class SashFormProxy < CompositeProxy
      attr_reader :weights, :orientation
      
      def initialize(parent, args, block)
        vertical = args.detect { |arg| SWTProxy[:vertical] == SWTProxy[arg] }
        @orientation = vertical ? 'vertical' : 'horizontal'
        super(parent, args, block)
      end
      
      # assumes 2 children
      def post_add_content
        child1 = dom_element.children.eq(0)
        child2 = dom_element.children.eq(1)
        unless child1.empty? || child2.empty?
          dom_element.sash(content1: "##{child1.attr('id')}", content2: "##{child2.attr('id')}")
          dom_element.sash('orientation', @orientation)
          dom_element.sash('ratio', @ratio)
          @initialized = true
        end
      end
      
      def orientation=(value)
        vertical = SWTProxy[:vertical] == SWTProxy[value]
        @orientation = vertical ? 'vertical' : 'horizontal'
        dom_element.sash('orientation', @orientation) if @initialized
      end
      
      # sets weights (in ratio to each other), assuming 2
      def weights=(*weights_array)
        @weights = weights_array
        @ratio = @weights.first / @weights.last
        dom_element.sash('ratio', @ratio) if @initialized
      end
      
      def element
        'div'
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
