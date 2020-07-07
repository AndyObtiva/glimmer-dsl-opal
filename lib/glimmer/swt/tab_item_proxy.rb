require 'glimmer/swt/composite_proxy'

module Glimmer
  module SWT
    class TabItemProxy < CompositeProxy
      include Glimmer
      attr_reader :text, :content_visible      
      
      def initialize(parent, args)
        super(parent, args)
        css_classes << 'tab-item'
        content {
          on_widget_selected {
            @parent.hide_all_tab_content
            show
          }
        }
      end
      
      def show
        # TODO refactor/rewrite via simply class application in jquery
#         Document.find(path).remove_class('hide')
        @content_visible = true
        redraw
      end
      
      def hide
        # TODO refactor/rewrite via simply class application in jquery
#         Document.find(path).add_class('hide')
        @content_visible = false
        redraw
      end
    
      def text=(value)
        @text = value
        redraw
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
      
      def redraw        
        if @tab_dom
          old_tab_dom = @tab_dom
          @tab_dom = nil
          Document.find(tab_path).replace_with(tab_dom)
        else
          Document.find(parent.tabs_path).append(tab_dom)
        end
        super()
      end
      
      def tab_path
        "#{parent.tabs_path} > ##{tab_id}"
      end
      
      def tab_id
        id + '-tab'
      end
        
      def tab_dom
        tab_selected = @content_visible ? 'selected' : ''
        @tab_dom ||= html {
          button(id: tab_id, class: "tab #{tab_selected}") {
            @text
          }
        }.to_s
      end
      
      def dom
        tab_item_id = id
        tab_item_id_style = css
        tab_item_css_classes = css_classes
        css_classes << name
        if @content_visible
          tab_item_css_classes.delete('hide')
        else
          tab_item_css_classes << 'hide' 
        end
        tab_item_class_string = tab_item_css_classes.to_a.join(' ')
        @dom ||= html {
          div(id: tab_item_id, style: tab_item_id_style, class: tab_item_class_string) {
          }
        }.to_s
      end      
    end
  end
end
