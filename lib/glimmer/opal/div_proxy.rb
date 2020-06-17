require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class DivProxy < ElementProxy
      def initialize(parent, args)
        super(parent, args)
        GridLayoutProxy.new(self, [])
      end
      
      def dom
        div_id = id
        div_style = style
        @dom ||= DOM {
          div(id: div_id, class: 'grid-layout', style: div_style)
        }
      end
    end
  end
end
