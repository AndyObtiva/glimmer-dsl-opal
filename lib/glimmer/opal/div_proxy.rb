require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class DivProxy < ElementProxy
      def dom
        div_id = id
        @dom ||= DOM {
          div(id: div_id, class: 'grid_layout')
        }
      end
    end
  end
end
