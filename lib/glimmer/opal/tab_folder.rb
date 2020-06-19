require 'glimmer/opal/div_proxy'

module Glimmer
  module Opal
    class TabFolder < ElementProxy
      attr_reader :tabs
      
      def initialize(parent, args)
        super(parent, args)
        @tabs = []
      end
      
      def add_child(child)
        super(child)
        if @children.size == 1
          child.show
        end
      end      
      
      def hide_all_tab_content
        @children.each(&:hide)
      end
    
      def name
        'div'
      end
      
      def tabs_dom
        tabs_id = id + '-tabs'
        @tabs_dom ||= DOM {
          div(id: tabs_id, class: 'tabs')
        }
      end
      
      def dom
        tab_folder_id = id
        tab_folder_id_style = css
        @dom ||= DOM {
          div(id: tab_folder_id, style: tab_folder_id_style, class: 'tab-folder') {
            
          }
        }.tap {|the_dom| the_dom << tabs_dom }
      end
    end
  end
end
