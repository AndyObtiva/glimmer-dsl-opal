require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class DivProxy < ElementProxy
      attr_reader :layout
      
      def initialize(parent, args)
        super(parent, args)
        @layout = GridLayoutProxy.new(self, [])
      end
      
      def dom
        div_id = id
        div_style = css
        @dom ||= DOM {
          div(id: div_id, class: 'grid-layout', style: div_style)
        }
      end
    end
  end
end
