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
          dom_element.timepicker({
            showPeriod: true,
            showLeadingZero: true
          })
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
          default_date = DateTime.new if @date_time.nil?
          default_year = @date_time&.year || default_date.year
          default_month = @date_time&.month || default_date.month
          default_day = @date_time&.day || default_date.day
          default_hour = @date_time&.hour || default_date.hour
          default_min = @date_time&.min || default_date.min
          default_sec = @date_time&.sec || default_date.sec
          if time?
            @date_time = DateTime.new(default_year, default_month, default_day, dom_element.timepicker('getHour').to_i, dom_element.timepicker('getMinute').to_i, default_sec)
          else
            @date_time = DateTime.new(dom_element.datepicker('getDate')&.year.to_i, dom_element.datepicker('getDate')&.month.to_i, dom_element.datepicker('getDate')&.day.to_i, default_hour, default_min, default_sec)
          end
          @date_time = @date_time&.to_datetime
        else
          @initial_date_time
        end
      end
      
      def date_time=(value)
        if @added_content
          @date_time = value&.to_datetime || DateTime.new
          if time?
            dom_element.timepicker('setTime', "#{@date_time.hour}:#{@date_time.min}")
          else
            dom_element.datepicker('setDate', @date_time.to_time)
          end
        else
          @initial_date_time = value
        end
      end
      
      # TODO add date, time, year, month, day, hours, minutes, seconds attribute methods
      
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
