require 'glimmer/opal/element_proxy'
require 'glimmer/opal/table_column'

module Glimmer
  module Opal
    class TableProxy < ElementProxy
      attr_reader :columns, :selection
      attr_accessor :column_properties
      alias items children
      
      def initialize(parent, args)
        super(parent, args)
        @columns = []
        @selection = []
        @children = []
      end
      
      # Only table_columns may be added as children
      def add_child(child)
        if child.is_a?(TableColumn)
          @columns << child
          columns_dom << child.dom
        else
          @children << child        
          items_dom << child.dom
        end
      end
      
      def remove_all
        items.each(&:dispose)
        items.clear
        @items_dom = nil
      end
      
      def selection=(new_selection)
        @selection = new_selection
        redraw
      end
      
      def items=(new_selection)
        @children = new_selection
        redraw
      end
      
      def search(&condition)
        items.select {|item| condition.nil? || condition.call(item)}
      end      
      
      def index_of(item)
        items.index(item)
      end
      
      def select(index, meta = false)
        # TODO consider unifying among multi-selectables (like multi list and multi tree)
        selected_item = items[index]
        if @selection.include?(selected_item)
          @selection.delete(selected_item) if meta
        else
          @selection = [] if !meta || (!has_style?(:multi) && @selection.to_a.size >= 1)
          @selection << selected_item
        end
        self.selection = @selection
      end
      
      def redraw
        if @last_redrawn_children != @children
          items_dom.clear
          @last_redrawn_children = @children
          @children = []
          @last_redrawn_children.each { |c| add_child(c) }
        end
        super()
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
