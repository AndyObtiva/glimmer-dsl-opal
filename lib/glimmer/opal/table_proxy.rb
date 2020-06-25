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
        @children = []
        @selection = []
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
        items.clear
        @items_dom = nil
      end
      
      def selection=(new_selection)
        changed = (@selection + new_selection) - (@selection & new_selection)
        @selection = new_selection
        changed.each(&:redraw)
      end
      
      def items=(new_items)
        @children = new_items
        redraw
      end
      
      def search(&condition)
        items.select {|item| condition.nil? || condition.call(item)}
      end      
      
      def index_of(item)
        items.index(item)
      end
      
      def select(index, meta = false)
        new_selection = @selection.clone
        selected_item = items[index]
        if @selection.include?(selected_item)
          new_selection.delete(selected_item) if meta
        else
          new_selection = [] if !meta || (!has_style?(:multi) && @selection.to_a.size >= 1)
          new_selection << selected_item
        end
        self.selection = new_selection
      end
      
      def redraw
        if @dom
          old_dom = @dom
          @dom = nil
          old_dom.replace dom
        else
          dom
        end
        if @last_redrawn_children != @children
          items_dom.clear
          @last_redrawn_children = @children
          @children = []
          @last_redrawn_children.each do |child|            
            add_child(child)
          end
        end
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
