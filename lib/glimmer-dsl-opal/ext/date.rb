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
end
