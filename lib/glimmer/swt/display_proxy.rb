require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class DisplayProxy < WidgetProxy
      class << self
        def instance
          @instance ||= new
        end
        
        attr_accessor :open_custom_shells_in_current_window
        alias open_custom_shells_in_current_window? open_custom_shells_in_current_window
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
      
      def beep
        # TODO (simulate beep from SWT display flashing the screen and making a noise if possible)
      end
      
      def async_exec(proc_tracker = nil, &block)
        block = proc_tracker unless proc_tracker.nil?
        queue = nil # general queue
        if !proc_tracker.nil? && proc_tracker.invoked_from.to_s == 'open' && modal_open? &&
           (
             proc_tracker.owner.is_a?(MessageBoxProxy) ||
             (dialog_open? && proc_tracker.owner.is_a?(DialogProxy) && opened_dialogs.last == WidgetProxy.widget_handling_listener&.dialog_ancestor)
           )
          queue = WidgetProxy.widget_handling_listener
        end
        schedule_async_exec(block, queue)
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
                  event.define_singleton_method(:keyCode) {event.which}
                  event.define_singleton_method(:key_code, &event.method(:keyCode))
                  event.define_singleton_method(:character) {event.which.chr}
                  event.define_singleton_method(:stateMask) do
                    state_mask = 0
                    state_mask |= SWTProxy[:alt] if event.alt_key
                    state_mask |= SWTProxy[:ctrl] if event.ctrl_key
                    state_mask |= SWTProxy[:shift] if event.shift_key
                    state_mask |= SWTProxy[:command] if event.meta_key
                    state_mask
                  end
                  event.define_singleton_method(:state_mask, &event.method(:stateMask))
                  doit = true
                  event.define_singleton_method(:doit=) do |value|
                    doit = value
                  end
                  event.define_singleton_method(:doit) { doit }
                  event_listener.call(event)
                  
                    # TODO Fix doit false, it's not stopping input
                  unless doit
                    event.prevent
                    event.prevent_default
                    event.stop_propagation
                    event.stop_immediate_propagation
                  end
                  
                  doit
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
                  event.define_singleton_method(:keyCode) {event.which}
                  event.define_singleton_method(:key_code, &event.method(:keyCode))
                  event.define_singleton_method(:character) {event.which.chr}
                  event.define_singleton_method(:stateMask) do
                    state_mask = 0
                    state_mask |= SWTProxy[:alt] if event.alt_key
                    state_mask |= SWTProxy[:ctrl] if event.ctrl_key
                    state_mask |= SWTProxy[:shift] if event.shift_key
                    state_mask |= SWTProxy[:command] if event.meta_key
                    state_mask
                  end
                  event.define_singleton_method(:state_mask, &event.method(:stateMask))
                  doit = true
                  event.define_singleton_method(:doit=) do |value|
                    doit = value
                  end
                  event.define_singleton_method(:doit) { doit }
                  event_listener.call(event) if event.key_code != 13 && (event.key_code == 127 || event.key_code <= 31)
                  
                    # TODO Fix doit false, it's not stopping input
                  unless doit
                    event.prevent
                    event.prevent_default
                    event.stop_propagation
                    event.stop_immediate_propagation
                  end
                  
                  doit
                }
              }
            }
          ]
        }
      end
      
      private
      
      def async_exec_queues
        @async_exec_queues ||= {}
      end
      
      def async_exec_queue(widget_handling_listener = nil)
        async_exec_queues[widget_handling_listener] ||= []
      end
      
      def no_widget_handling_listener_work?
        async_exec_queues.reject {|key, value| key.nil?}.values.reduce(:+).to_a.empty?
      end
      
      def schedule_async_exec(block, queue)
        async_exec_queue(queue).unshift(block)
        
        # TODO consider the need for locking to avoid race conditions (rare or impossible case)
        if async_exec_queue(queue).size == 1
          executer = lambda do
            # queue could be a widget handling listener queue
            # TODO see if there are more intricate cases of opening a dialog from a widget listener handler
            if !message_box_open? && (!dialog_open? || queue&.dialog_ancestor == opened_dialogs.last) && ((!queue.nil? && async_exec_queues.keys.last == queue) || no_widget_handling_listener_work?)
              block = async_exec_queue(queue).pop
              block&.call
              Async::Task.new(delay: 1, &executer) if async_exec_queue(queue).any?
            else
              Async::Task.new(delay: 100, &executer)
            end
          end
          Async::Task.new(delay: 1, &executer)
        end
      end
    end
  end
end
