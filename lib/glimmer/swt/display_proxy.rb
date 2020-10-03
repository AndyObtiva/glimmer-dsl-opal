module Glimmer
  module SWT
    class DisplayProxy
      class << self
        def instance
          @instance ||= new
        end
      end
      
      def async_exec(&block)
        executer = lambda do
          if Document.find('.modal').to_a.empty?
            block.call
          else
            sleep(0.05)
            Async::Task.new(&executer)
          end
        end
        Async::Task.new(&executer)
      end
      # sync_exec kept for API compatibility reasons
      alias sync_exec async_exec
    end
  end
end
