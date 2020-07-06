require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TabFolderProxy < WidgetProxy      
      attr_reader :tabs
      
      def initialize(parent, args)
        super(parent, args)
        @tabs = []
      end
      
      def add_child(child)
        unless @children.include?(child)
          @children << child
          Document.find("##{tabs_id}").append(child.tab_dom)
          Document.find(path).append(child.dom)
        end
        if @children.size == 1
          child.show
        end
      end
      
      def redraw
        super()
        @children.each do |child|
          add_child(child) # TODO think of impact of this on performance
        end
      end
      
      def hide_all_tab_content
        @children.each(&:hide)
      end
    
      def name
        'div'
      end
      
      def tabs_path
        path + " > ##{tabs_id}"
      end
      
      def tabs_id
        id + '-tabs'
      end
      
      def dom
        tab_folder_id = id
        tab_folder_id_style = css
        @dom ||= html {
          div(id: tab_folder_id, style: tab_folder_id_style, class: 'tab-folder') {
            div(id: tabs_id, class: 'tabs')
          }
        }.to_s
      end
    end
  end
end
