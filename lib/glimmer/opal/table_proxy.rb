require 'glimmer/opal/element_proxy'
require 'glimmer/opal/table_column'

module Glimmer
  module Opal
    class TableProxy < ElementProxy
      attr_reader :items, :columns, :selection
      attr_accessor :column_properties
      
      def initialize(parent, args)
        super(parent, args)
        @items = []
        @columns = []
        @selection = []
      end
      
      # Only table_columns may be added as children
      def add_child(child)
        if child.is_a?(TableColumn)
          @columns << child
          columns_dom << child.dom
        else
          @items << child
          items_dom << child.dom
        end
      end
      
      def remove_all
        @items = []
        @items_dom = nil
        redraw
      end
      
      def items=(value)
        @items = value
        redraw
      end
      
      def selection=(value)
        @selection = value
        # TODO redraw selection properly as per list selection
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
      
      def items_dom        
        @items_dom ||= DOM {
          tbody {
          }
        }
      end
      
      def dom
        table_id = id
        table_id_style = css
        table_id_css_classes = css_classes
        table_id_css_classes_string = table_id_css_classes.to_a.join(' ')
        @dom ||= DOM {
          table(id: table_id, style: table_id_style, class: table_id_css_classes_string) {            
          }
        }.tap {|the_dom| the_dom >> thead_dom }.tap {|the_dom| the_dom << items_dom }
      end
    end
  end
end
