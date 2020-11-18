require 'glimmer/swt/composite_proxy'

module Glimmer
  module SWT
    class TabItemProxy < CompositeProxy
      include Glimmer
      attr_reader :text, :content_visible
      
      def initialize(parent, args, block)
        super(parent, args, block)
        content {
          on_widget_selected {
            @parent.hide_all_tab_content
            show
          }
        }
      end
      
      def show
        @content_visible = true
        dom_element.remove_class('hide')
        tab_dom_element.add_class('selected')
      end
      
      def hide
        @content_visible = false
        dom_element.add_class('hide')
        tab_dom_element.remove_class('selected')
      end
    
      def text=(value)
        @text = value
        tab_dom_element.html(@text)
      end
    
      def selector
        super + '-tab'
      end
      
      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click'
          },
        }
      end
      
      def listener_path
        tab_path
      end
      
      def tab_path
        "#{parent.tabs_path} > ##{tab_id}"
      end
      
      def tab_dom_element
        Document.find(tab_path)
      end
      
      def tab_id
        id + '-tab'
      end
        
      # This contains the clickable tab area with tab names
      def tab_dom
        @tab_dom ||= html {
          button(id: tab_id, class: "tab") {
            @text
          }
        }.to_s
      end
      
      # This contains the tab content
      def dom
        tab_item_id = id
        tab_item_class_string = [name, 'hide'].join(' ')
        @dom ||= html {
          div(id: tab_item_id, class: tab_item_class_string) {
          }
        }.to_s
      end
    end
  end
end
