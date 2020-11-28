require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/table_column_proxy'

module Glimmer
  module SWT
    class TableProxy < WidgetProxy
      attr_reader :columns, :selection
      attr_accessor :column_properties
      alias items children
      
      def initialize(parent, args, block)
        super(parent, args, block)
        @columns = []
        @children = []
        @selection = []
        if editable?
          content {
            on_mouse_up { |event|
              edit_table_item(event.table_item, event.column_index)
            }
          }
        end
      end
      
      # Only table_columns may be added as children
      def post_initialize_child(child)
        if child.is_a?(TableColumnProxy)
          @columns << child
        else
          @children << child
        end
        child.redraw
      end
      
      def remove_all
        items.clear
        redraw
      end
      
      def editable?
        args.include?(:editable)
      end
      alias editable editable?
      
      def selection=(new_selection)
        changed = (@selection + new_selection) - (@selection & new_selection)
        @selection = new_selection
        changed.each(&:redraw)
      end
            
      def items=(new_items)
        @children = new_items
        redraw
      end
      
      def cells_for(model)
        column_properties.map {|property| model.send(property)}
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
      
      def edit_table_item(table_item, column_index)
        table_item.edit(column_index)
      end
      
      def selector
        super + ' tbody'
      end
      
      def observation_request_to_event_mapping
        mouse_handler = -> (event_listener) {
          -> (event) {
            event.singleton_class.send(:define_method, :table_item=) do |item|
              @table_item = item
            end
            event.singleton_class.send(:define_method, :table_item) do
              @table_item
            end
            table_row = event.target.parents('tr').first
            table_data = event.target.parents('td').first
            event.table_item = items.detect {|item| item.id == table_row.attr('id')}
            event.singleton_class.send(:define_method, :column_index) do
              (table_data || event.target).attr('data-column-index')
            end
            event_listener.call(event)
          }
        }

        {
          'on_mouse_down' => {
            event: 'mousedown',
            event_handler: mouse_handler,
          },
          'on_mouse_up' => {
            event: 'mouseup',
            event_handler: mouse_handler,
          }
        }
      end
      
      def redraw
        super()
        @columns.to_a.each(&:redraw)
      end
      
      def element
        'table'
      end
      
      def columns_path
        path + ' thead tr'
      end

      def columns_dom_element
        Document.find(columns_path)
      end
      
      def items_path
        path + ' tbody'
      end

      def items_dom_element
        Document.find(items_path)
      end
      
      def columns_dom
        tr {
        }
      end
      
      def thead_dom
        thead {
          columns_dom
        }
      end
      
      def items_dom
        tbody {
        }
      end
      
      def dom
        table_id = id
        table_id_style = css
        table_id_css_classes = css_classes
        table_id_css_classes << 'table'
        table_id_css_classes_string = table_id_css_classes.to_a.join(' ')
        @dom ||= html {
          table(id: table_id, style: table_id_style, class: table_id_css_classes_string) {
            thead_dom
            items_dom
          }
        }.to_s
      end
    end
  end
end
