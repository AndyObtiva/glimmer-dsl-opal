require 'glimmer/swt/composite_proxy'

module Glimmer
  module SWT
    class SashFormProxy < CompositeProxy
      def post_add_content
        child1 = dom_element.children.eq(0)
        child2 = dom_element.children.eq(1)
        dom_element.sash({content1: "##{child1.attr('id')}", content2: "##{child2.attr('id')}"}) if child1 && child2
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
