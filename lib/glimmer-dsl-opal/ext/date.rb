require 'date'
require 'time'

class DateTime < Date
  def initialize(*args, &block)
    @time = Time.new(*args, &block)
    methods_to_exclude = [:to_date, :to_time, :==, :eql?, :class]
    methods_to_define = @time.methods - methods_to_exclude
    methods_to_define.each do |method|
      singleton_class.define_method(method) do |*args, &block|
        @time.send(method, *args, &block)
      end
    end
  end
  
  def to_date
    @time.to_date
  end
  
  def to_time
    @time
  end
  
  def ==(other)
    return false if other.class != self.class
    year == other.year and
      month == other.month and
      day == other.day and
      hour == other.hour and
      min == other.min and
      sec == other.sec
  end
  alias eql? ==
end

class Date
  def to_datetime
    # TODO support timezone
    DateTime.new(year, month, day, hour, min, sec)
  end
end

class Time
  def to_datetime
    # TODO support timezone
    DateTime.new(year, month, day, hour, min, sec)
  end
end
