require 'date'
require 'time'

class DateTime < Date
  def initialize(*args, &block)
    @time = Time.new(*args, &block)
    @time.methods.each do |method|
      singleton_class.define_method(method) do |*args, &block|
        @time.send(method, *args, &block)
      end
    end
  end
  
  def to_time
    @time
  end
  
  def to_date
    @time.to_date
  end
end

class Date
  def to_datetime
    # TODO support timezone
    DateTime.new(year, month, day, hour, min, sec)
  end
end

class Time
  def to_datetime
    DateTime.new(year, month, day, hour, min, sec)
  end
end
