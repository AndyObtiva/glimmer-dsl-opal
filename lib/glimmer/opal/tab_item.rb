require 'glimmer/opal/input_proxy'

module Glimmer
  module Opal
    class TabItem < DivProxy
      attr_reader :text
    
      def text=(value)
        puts 'setting text'
        puts value
        @text = value
        redraw
      end
    
      def name
        'div'
      end
      
      def redraw        
        if @tab_dom
          puts 'redrawing'
          old_tab_dom = @tab_dom
          @tab_dom = nil
          old_tab_dom.replace tab_dom
        else
          tab_dom
        end
        super
      end      
      
      def tab_dom
        tab_id = id + '-tab'
        tab_text = text
        @tab_dom ||= DOM {
          button(id: tab_id, class: 'tab') {
            tab_text
          }
        }
      end
      
      def dom
        tab_item_id = id
        tab_item_id_style = css
        if !@parent.tabs.include?(self)
          puts 'including tab ' + text.to_s
          @parent.tabs_dom << tab_dom
          @parent.tabs << self
        end
        @dom ||= DOM {
          div(id: tab_item_id, style: tab_item_id_style, class: 'tab-item') {
          }
        }
      end      
    end
  end
end
