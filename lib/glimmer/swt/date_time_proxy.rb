require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class DateTimeProxy < WidgetProxy
      class << self
        def create(keyword, parent, args)
          case keyword
          when 'date'
            args += [:date]
          when 'date_drop_down'
            args += [:date, :drop_down]
          when 'time'
            args += [:time]
          when 'calendar'
            args += [:calendar]
          end
          new(parent, args)
        end
      end
      
      def initialize(parent, args)
        super(parent, args)
      end
      
      def post_add_content
        # TODO handle date_drop_down version
        if time?
          dom_element.timepicker
        else
          dom_element.datepicker
        end
        date_time_value = self.date_time
        @added_content = true
        self.date_time = date_time_value
      end
      
      def date?
        args.to_a.include?(:date)
      end
      
      def time?
        args.to_a.include?(:time)
      end
      
      def drop_down?
        args.to_a.include?(:drop_down)
      end
      
      def calendar?
        args.to_a.include?(:calendar)
      end
      
      def date_time
        if @added_content
          dom_element.datepicker('getDate')&.to_datetime
        else
          @initial_date_time
        end
      end
      
      def date_time=(value)
        if @added_content
          dom_element.datepicker('setDate', value.to_time) unless value.nil?
        else
          @initial_date_time = value
        end
      end
      
      # TODO add year, month, day, hours, minutes, seconds attribute methods
      
      def observation_request_to_event_mapping
        {
          'on_widget_selected' => [
            {
              event: 'change'
            },
          ],
        }
      end
      
      def element
        calendar? ? 'div' : 'input'
      end
      
      def dom
        @dom ||= html {
          send(element, type: 'text', id: id, class: name)
        }.to_s
      end
      
    end
    
    # Aliases: `date`, `date_drop_down`, `time`, and `calendar`
    DateProxy         = DateTimeProxy
    DateDropDownProxy = DateTimeProxy
    TimeProxy         = DateTimeProxy
    CalendarProxy     = DateTimeProxy
    
  end
  
end
