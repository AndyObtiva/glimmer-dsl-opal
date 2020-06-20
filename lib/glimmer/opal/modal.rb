require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class Modal < ElementProxy
      attr_reader :text, :message
      
      def initialize(parent, args)
        puts 'modal'
        i = 0
        @parent = parent
        puts i+= 1
        @args = args
        puts i+= 1
        @children = Set.new
        puts i+= 1
        @css_classes = Set.new(['modal'])
        puts i+= 1
        @css = ''
        puts i+= 1
        @enabled = true
        puts i+= 1
        content do
          on_widget_selected {
            puts 'hiding...'
            hide
            puts 'hidden'
          }
        end
        puts i+= 1
        puts 'finished modal'
      end
      
      def text=(txt)
        @text = txt
        redraw if @dom
      end
    
      def message=(msg)
        @message = msg
        redraw if @dom
      end
      
      def document
        element = self
        begin
          element = element.parent
          puts 'element'
          puts element.inspect
        end while(element.parent)
        element
      end
      
      def open
        puts 'open'
        puts 'open adding child'
        document.add_child(self)
        puts "css_classes.include?('hide')"
        puts css_classes.include?('hide')
#         until css_classes.include?('hide')
#           sleep(0.01)
#         end
      end
      
      def hide
        dom.remove
      end
      
      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::Opal::MessageBoxExpression.new, &block)
      end
      
      def name
        'div'
      end
      
      def selector
        super + ' .close' 
      end
    
      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click'
          },
        }
      end      
      
      def dom
        modal_id = id
        modal_style = css
        modal_text = text
        modal_message = message
        modal_css_classes = css_classes
        modal_class = modal_css_classes.to_a.join(' ')
        @dom ||= DOM {        
          div(id: modal_id, style: modal_style, class: modal_class) {
            div(class: 'modal-content') {
              header.text {
                modal_text
              }
              p.message {
                modal_message
              }
              input(type: 'button', class: 'close', autofocus: 'autofocus', value: 'OK')
            }
          }
        }
      end
    end
  end
end

require 'glimmer/dsl/opal/message_box_expression'
