require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class MessageBoxProxy < WidgetProxy
      attr_reader :text, :message
      
      def initialize(parent, args)
        i = 0
        @parent = parent
        @args = args
        @children = Set.new
        @css_classes = Set.new(['modal', name])
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
        dom_element.remove
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
    
      def listener_path
        path + ' .close' 
      end
    
      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click'
          },
        }
      end      
 
      def style_dom_modal_css
        <<~CSS
          .modal {
            position: fixed;
            z-index: 1;
            padding-top: 100px;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
            text-align: center;
          }
          .modal-content .text {
            background: rgb(80, 116, 211);
            color: white;
            padding: 5px;
          }
          .modal-content .message {
            padding: 20px;
          }
          .modal-content {
            background-color: #fefefe;
            margin: auto;
            border: 1px solid #888;
            display: inline-block;
            min-width: 200px;
          }
        CSS
#           .close {
#             color: #aaaaaa;
#             float: right;
#             font-weight: bold;
#             margin: 5px;
#           }
#           .close:hover,
#           .close:focus {
#             color: #000;
#             text-decoration: none;
#             cursor: pointer;
#           }
      end
      
      def dom
        modal_id = id
        modal_style = css
        modal_text = text
        modal_message = message
        modal_css_classes = css_classes
        modal_class = modal_css_classes.to_a.join(' ')
        @dom ||= html {        
          div(id: modal_id, style: modal_style, class: modal_class) {
            style(class: 'modal-style') {
              style_dom_modal_css #.split("\n").map(&:strip).join(' ')
            }        
            div(class: 'modal-content') {
              header(class: 'text') {
                modal_text
              }
              tag(_name: 'p', id: 'message') {
                modal_message
              }
              input(type: 'button', class: 'close', autofocus: 'autofocus', value: 'OK')
            }
          }
        }.to_s
      end
    end
  end
end

require 'glimmer/dsl/opal/message_box_expression'
