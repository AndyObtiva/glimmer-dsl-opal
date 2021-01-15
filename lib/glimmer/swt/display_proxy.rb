require 'glimmer/swt/widget_proxy'

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
      
      def dialogs
        @dialogs ||= []
      end
      
      def modals
        message_boxes + dialogs
      end
      
      def message_box_open?
        message_boxes.any?(&:open?)
      end
      
      def dialog_open?
        dialogs.any?(&:open?)
      end
      
      def opened_dialogs
        dialogs.select(&:open?)
      end
      
      def modal_open?
        message_box_open? or dialog_open?
      end
      
      def render
        # No rendering as body is rendered as part of ShellProxy.. this class only serves as an SWT Display utility
      end
      
      def async_exec(proc_tracker = nil, &block)
        block = proc_tracker unless proc_tracker.nil?
        can_open_modal = !modal_open?
        return block.call if !can_open_modal && dialog_open? && block.respond_to?(:owner) && !block.owner.nil? && block.owner.is_a?(DialogProxy) && opened_dialogs.last == WidgetProxy.widget_handling_listener&.dialog_ancestor
        return block.call if !can_open_modal && block.respond_to?(:owner) && !block.owner.nil? && block.owner.is_a?(MessageBoxProxy)
        executer = lambda do
          if !modal_open?
            block.call
          else
            Async::Task.new(delay: 100, &executer)
          end
        end
        Async::Task.new(delay: 1, &executer)
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
