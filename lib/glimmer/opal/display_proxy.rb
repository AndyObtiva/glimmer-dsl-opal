module Glimmer
  module Opal
    class DisplayProxy
      class << self
        def instance
          @instance ||= new
        end
      end
      
      def async_exec(&block)
        executer = lambda do
          if $document.at_css('.modal')
            sleep(0.05)
            Async::Task.new(&executer)
          else
            block.call
          end
        end
        Async::Task.new(&executer)
      end
    end
  end
end
