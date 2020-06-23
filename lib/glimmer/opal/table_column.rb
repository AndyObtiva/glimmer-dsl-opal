require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class TableColumn < ElementProxy
      include Glimmer
      attr_reader :text, :width      
      
      def text=(value)
        @text = value
        redraw
      end
    
      def width=(value)
        @width = value
        redraw
      end
      
      def css
        <<~CSS
          width: #{width};
        CSS
      end
    
      def name
        'th'
      end
      
      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click'
          },
        }
      end      
      
      def dom
        table_column_text = text
        table_column_id = id
        table_column_id_style = css
        table_column_css_classes = css_classes
        @dom ||= DOM {
          th(id: table_column_id, style: table_column_id_style, class: table_column_css_classes.to_a.join(' ')) {
            table_column_text
          }
        }
      end      
    end
  end
end
