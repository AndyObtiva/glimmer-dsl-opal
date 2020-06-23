require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class TableProxy < ElementProxy
      attr_reader :items, :columns
      
      def initialize(parent, args)
        super(parent, args)
        @items = []
        @columns = []
      end
      
      # Only table_columns may be added as children
      def add_child(column)
        @columns << column
        columns_dom << column.dom
      end
      
      def items=(value)
        @items = value
        redraw
      end

      def columns_dom        
        @columns_dom ||= DOM {
          tr {
          }
        }
      end
      
      def thead_dom
        @thead_dom ||= DOM {
          thead {
          }
        }.tap {|the_dom| the_dom << columns_dom }
      end
      
      def dom
        table_id = id
        table_id_style = css
        table_id_css_classes = css_classes
        table_id_css_classes_string = table_id_css_classes.to_a.join(' ')
        @dom ||= DOM {
          table(id: table_id, style: table_id_style, class: table_id_css_classes_string) {
            
          }
        }.tap {|the_dom| the_dom >> thead_dom }
      end
    end
  end
end
