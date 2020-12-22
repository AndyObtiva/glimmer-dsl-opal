module Glimmer
  module SWT
    class DisplayProxy < WidgetProxy
      class << self
        def instance
          @instance ||= new
        end
      end
      
      def initialize
        # Do not call super
      end
      
      def path
        "html body"
      end

      # Root element representing widget. Must be overridden by subclasses if different from div
      def element
        'body'
      end
      
      def listener_dom_element
        Document
      end
      
      def shells
        @shells ||= []
      end
      
      def message_boxes
        @message_boxes ||= []
      end
      alias message_boxs message_boxes # ensures consistency when meta-programming plurals based on s suffix
      
      def render
        # No rendering as body is rendered as part of ShellProxy.. this class only serves as an SWT Display utility
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
      
      def observation_request_to_event_mapping
        {
          'on_swt_keydown' => [
            {
              event: 'keypress',
              event_handler: -> (event_listener) {
                -> (event) {
                  event.singleton_class.define_method(:character) do
                    which || key_code
                  end
                  event_listener.call(event)
                }
              }
            },
            {
              event: 'keydown',
              event_handler: -> (event_listener) {
                -> (event) {
                  event.singleton_class.define_method(:character) do
                    which || key_code
                  end
                  event_listener.call(event) if event.key_code != 13 && (event.key_code == 127 || event.key_code <= 31)
                }
              }
            }
          ]
        }
      end
    end
  end
end
