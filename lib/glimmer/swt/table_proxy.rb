require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/table_column_proxy'

module Glimmer
  module SWT
    class TableProxy < WidgetProxy
      attr_reader :columns, :selection,
                  :sort_type, :sort_column, :sort_property, :sort_block, :sort_by_block, :additional_sort_properties
      attr_accessor :column_properties, :item_count, :data
      alias items children
      alias model_binding data
      
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
      
      def get_data(key=nil)
        data
      end
      
      def remove_all
        items.clear
        redraw
      end
      
      def editable?
        args.include?(:editable)
      end
      alias editable editable?
      
      def selection
        @selection.to_a
      end
      
      def selection=(new_selection)
        new_selection = new_selection.to_a
        changed = (selection + new_selection) - (selection & new_selection)
        @selection = new_selection
        changed.each(&:redraw)
      end
            
      def items=(new_items)
        @children = new_items
        redraw
      end
      
      def item_count=(value)
        @item_count = value
        redraw_empty_items
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
      
      def search(&condition)
        items.select {|item| condition.nil? || condition.call(item)}
      end
      
      def sort_block=(comparator)
        @sort_block = comparator
      end
      
      def sort_by_block=(property_picker)
        @sort_by_block = property_picker
      end
      
      def sort_property=(new_sort_property)
        @sort_property = [new_sort_property].flatten.compact
      end
      
      def detect_sort_type
        @sort_type = sort_property.size.times.map { String }
        array = model_binding.evaluate_property
        sort_property.each_with_index do |a_sort_property, i|
          values = array.map { |object| object.send(a_sort_property) }
          value_classes = values.map(&:class).uniq
          if value_classes.size == 1
            @sort_type[i] = value_classes.first
          elsif value_classes.include?(Integer)
            @sort_type[i] = Integer
          elsif value_classes.include?(Float)
            @sort_type[i] = Float
          end
        end
      end
      
      def column_sort_properties
        column_properties.zip(table_column_proxies.map(&:sort_property)).map do |pair|
          [pair.compact.last].flatten.compact
        end
      end
      
      def sort_direction
        @sort_direction == :ascending ? SWTProxy[:up] : SWTProxy[:down]
      end
      
      def sort_direction=(value)
        @sort_direction = value == SWTProxy[:up] ? :ascending : :descending
      end
      
      # Sorts by specified TableColumnProxy object. If nil, it uses the table default sort instead.
      def sort_by_column!(table_column_proxy=nil)
        index = columns.to_a.index(table_column_proxy) unless table_column_proxy.nil?
        new_sort_property = table_column_proxy.nil? ? @sort_property : table_column_proxy.sort_property || [column_properties[index]]
        return if table_column_proxy.nil? && new_sort_property.nil? && @sort_block.nil? && @sort_by_block.nil?
        if new_sort_property && table_column_proxy.nil? && new_sort_property.size == 1 && (index = column_sort_properties.index(new_sort_property))
          table_column_proxy = table_column_proxies[index]
        end
        if new_sort_property && new_sort_property.size == 1 && !additional_sort_properties.to_a.empty?
          selected_additional_sort_properties = additional_sort_properties.clone
          if selected_additional_sort_properties.include?(new_sort_property.first)
            selected_additional_sort_properties.delete(new_sort_property.first)
            new_sort_property += selected_additional_sort_properties
          else
            new_sort_property += additional_sort_properties
          end
        end
        
        @sort_direction = @sort_direction.nil? || @sort_property.first != new_sort_property.first || @sort_direction == :descending ? :ascending : :descending
        
        @sort_property = [new_sort_property].flatten.compact
        table_column_index = column_properties.index(new_sort_property.to_s.to_sym)
        table_column_proxy ||= table_column_proxies[table_column_index] if table_column_index
        @sort_column = table_column_proxy if table_column_proxy
                
        if table_column_proxy
          @sort_by_block = nil
          @sort_block = nil
        end
        @sort_type = nil
        if table_column_proxy&.sort_by_block
          @sort_by_block = table_column_proxy.sort_by_block
        elsif table_column_proxy&.sort_block
          @sort_block = table_column_proxy.sort_block
        else
          detect_sort_type
        end
                
        sort!
      end
      
      def initial_sort!
        sort_by_column!
      end
      
      def sort!
        return unless sort_property && (sort_type || sort_block || sort_by_block)
        array = model_binding.evaluate_property
        array = array.sort_by(&:hash) # this ensures consistent subsequent sorting in case there are equivalent sorts to avoid an infinite loop
        # Converting value to_s first to handle nil cases. Should work with numeric, boolean, and date fields
        if sort_block
          sorted_array = array.sort(&sort_block)
        elsif sort_by_block
          sorted_array = array.sort_by(&sort_by_block)
        else
          sorted_array = array.sort_by do |object|
            sort_property.each_with_index.map do |a_sort_property, i|
              value = object.send(a_sort_property)
              # handle nil and difficult to compare types gracefully
              if sort_type[i] == Integer
                value = value.to_i
              elsif sort_type[i] == Float
                value = value.to_f
              elsif sort_type[i] == String
                value = value.to_s
              end
              value
            end
          end
        end
        sorted_array = sorted_array.reverse if @sort_direction == :descending
        model_binding.call(sorted_array)
      end
      
      def additional_sort_properties=(args)
        @additional_sort_properties = args unless args.empty?
      end
      
      def edit_table_item(table_item, column_index)
        table_item&.edit(column_index) unless column_index.nil?
      end
      
      def header_visible=(value)
        @header_visible = value
        if @header_visible
          thead_dom_element.remove_class('hide')
        else
          thead_dom_element.add_class('hide')
        end
      end
      
      def header_visible
        @header_visible
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
          },
          'on_widget_selected' => {
            event: 'mouseup',
          }
        }
      end
      
      def redraw
        super()
        @columns.to_a.each(&:redraw)
        redraw_empty_items
      end
      
      def redraw_empty_items
        if @children&.size.to_i < item_count.to_i
          item_count.to_i.times do
            empty_columns = column_properties&.size.to_i.times.map { |i| "<td data-column-index='#{i}'></td>" }
            items_dom_element.append("<tr class='table-item empty-table-item'>#{empty_columns}</tr>")
          end
        end
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
      
      def thead_dom_element
        dom_element.find('thead')
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
      
      private

      def property_type_converters
        super.merge({
          selection: lambda do |value|
            if value.is_a?(Array)
              search {|ti| value.include?(ti.get_data) }
            else
              search {|ti| ti.get_data == value}
            end
          end,
        })
      end
      
    end
    
  end
  
end
