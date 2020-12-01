require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TableColumnProxy < WidgetProxy
      include Glimmer
      
      attr_accessor :sort_block, :sort_by_block
      attr_reader :text, :width,
                  :no_sort, :sort_property, :editor
      alias no_sort? no_sort
      
      def initialize(parent, args, block)
        @no_sort = args.delete(:no_sort)
        super(parent, args, block)
        unless no_sort?
          content {
            on_widget_selected { |event|
              parent.sort_by_column!(self)
            }
          }
        end
      end
      
      def sort_property=(args)
        @sort_property = args unless args.empty?
      end
            
      def text=(value)
        @text = value
        redraw
      end
    
      def width=(value)
        @width = value
        redraw
      end
      
      def parent_path
        parent.columns_path
      end
      
      def css
        <<~CSS
          width: #{width}px;
        CSS
      end
    
      def element
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
        table_column_css_classes << name
        @dom ||= html {
          th(id: table_column_id, style: table_column_id_style, class: table_column_css_classes.to_a.join(' ')) {
            table_column_text
          }
        }.to_s
      end
    end
  end
end
