require 'glimmer/swt/composite_proxy'

module Glimmer
  module SWT
    class SashFormProxy < CompositeProxy
      attr_reader :weights
      
      # assumes 2 children
      def post_add_content
        child1 = dom_element.children.eq(0)
        child2 = dom_element.children.eq(1)
        if child1 && child2
          dom_element.sash(content1: "##{child1.attr('id')}", content2: "##{child2.attr('id')}")
          dom_element.sash('orientation', 'horizontal') # TODO make an attribute default
          dom_element.sash('ratio', @ratio)
        end
      end
      
      # sets weights (in ratio to each other), assuming 2
      def weights=(*weights_array)
        @weights = weights_array
        @ratio = @weights.first / @weights.last
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
