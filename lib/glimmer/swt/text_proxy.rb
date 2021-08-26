require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TextProxy < WidgetProxy
      attr_reader :text, :border, :left, :center, :right, :read_only, :wrap, :multi
      alias border? border
      alias left? left
      alias center? center
      alias right? right
      alias read_only? read_only
      alias wrap? wrap
      alias multi? multi
      
      def initialize(parent, args, block)
        args << :border if args.empty?
        @border = !!args.detect { |arg| SWTProxy[arg] == SWTProxy[:border] }
        @left = !!args.detect { |arg| SWTProxy[arg] == SWTProxy[:left] }
        @center = !!args.detect { |arg| SWTProxy[arg] == SWTProxy[:center] }
        @right = !!args.detect { |arg| SWTProxy[arg] == SWTProxy[:right] }
        @read_only = !!args.detect { |arg| SWTProxy[arg] == SWTProxy[:read_only] }
        @wrap = !!args.detect { |arg| SWTProxy[arg] == SWTProxy[:wrap] }
        @multi = !!args.detect { |arg| SWTProxy[arg] == SWTProxy[:multi] }
        super(parent, args, block)
      end

      def text=(value)
        @text = value
        Document.find(path).value = value
      end
      
      def element
        @wrap || @multi ? 'textarea' : 'input'
      end
      
      def observation_request_to_event_mapping
        myself = self
        {
          'on_verify_text' => [
            {
              event: 'beforeinput',
              event_handler: -> (event_listener) {
                -> (event) {
                  puts 'event'
                  puts event
                  puts "event.methods.sort - Object.methods"
                  puts event.methods.sort - Object.methods
                  `window.event1 = #{event.to_n}.originalEvent`
                  `console.log(#{event.to_n}.originalEvent.getTargetRanges())`
                  # TODO consider unifying this event handler with on_key_pressed by relying on its result instead of hooking another keyup event
                  # TODO add all attributes for on_modify_text modify event
                  event.define_singleton_method(:widget) {myself}
                  event.define_singleton_method(:text) {`#{event.to_n}.originalEvent.data`}
                  event.define_singleton_method(:start) {event.target.value.size}
                  event.define_singleton_method(:end) {event.target.value.size}
                  doit = true
                  event.define_singleton_method(:doit=) do |value|
                    puts 'setting doit to value'
                    puts value
                    doit = value
                  end
                  event.define_singleton_method(:doit) { doit }
                  puts 'event_listener'
                  puts event_listener
                  event_listener.call(event)
                  
                  puts 'event.doit'
                  puts event.doit
                  puts 'doit'
                  puts doit
  
                  if !doit
                    `#{event.to_n}.originalEvent.returnValue = false`
                  end
                  
                  doit
                }
              }
            },
            {
              event: 'input',
              event_handler: -> (event_listener) {
                -> (event) {
                  event.define_singleton_method(:widget) {myself}
                  @text = event.target.value
                  puts '@text'
                  puts @text
                }
              }
            }
          ],
          'on_modify_text' => [
            {
              event: 'input',
              event_handler: -> (event_listener) {
                -> (event) {
                  event.define_singleton_method(:widget) {myself}
                  @text = event.target.value
                  event_listener.call(event)
                  puts '@text'
                  puts @text
                }
              }
            }
          ],
        }
      end
      
      def dom
        text_text = @text
        text_id = id
        text_style = 'min-width: 27px; '
        text_style += 'border: none; ' if !@border
        text_style += 'text-align: left; ' if @left
        text_style += 'text-align: center; ' if @center
        text_style += 'text-align: right; ' if @right
        text_class = name
        options = {type: 'text', id: text_id, style: text_style, class: text_class, value: text_text}
        options = options.merge('disabled': 'disabled') unless @enabled
        options = options.merge('readonly': 'readonly') if @read_only
        options = options.merge('contenteditable': 'true')
        options = options.merge(type: 'password') if has_style?(:password)
        @dom ||= html {
          send(element, options)
        }.to_s
      end
    end
  end
end
