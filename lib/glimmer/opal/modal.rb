require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class Modal < ElementProxy
      attr_reader :text, :message
      
      def initialize(parent, args)
        i = 0
        @parent = parent
        @args = args
        @children = Set.new
        @css_classes = Set.new(['modal'])
        @css = ''
        @enabled = true
        content do
          on_widget_selected {
            hide
          }
        end
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
        end while(element.parent)
        element
      end
      
      def open
        document.add_child(self)
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
