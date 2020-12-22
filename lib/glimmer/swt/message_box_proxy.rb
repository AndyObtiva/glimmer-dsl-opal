# Copyright (c) 2020 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/display_proxy'

module Glimmer
  module SWT
    class MessageBoxProxy < WidgetProxy
      STYLE = <<~CSS
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
          padding-bottom: 15px;
          border: 1px solid #888;
          display: inline-block;
          min-width: 200px;
        }
      CSS
#         .close {
#           color: #aaaaaa;
#           float: right;
#           font-weight: bold;
#           margin: 5px;
#         }
#         .close:hover,
#         .close:focus {
#           color: #000;
#           text-decoration: none;
#           cursor: pointer;
#         }
      
      attr_reader :text, :message
      
      def initialize(parent, args, block)
        i = 0
        @parent = parent
        @parent = nil if parent.is_a?(LatestShellProxy)
        @parent ||= DisplayProxy.instance.shells.last || ShellProxy.new([])
        @args = args
        @block = block
        @children = Set.new
        @enabled = true
        on_widget_selected {
          hide
        }
        DisplayProxy.instance.message_boxes << self
      end
      
      def text=(txt)
        @text = txt
        dom_element.find('.modal-content .text').html(@text)
      end
    
      def html_message
        message&.gsub("\n", '<br />')
      end
      
      def message=(msg)
        @message = msg
        dom_element.find('.modal-content .message').html(html_message)
      end
      
      def open
        parent.post_initialize_child(self)
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
 
      def dom
        @dom ||= html {
          div(id: id, class: "modal #{name}") {
            div(class: 'modal-content') {
              header(class: 'text') {
                text
              }
              tag(_name: 'p', id: 'message', class: 'message') {
                html_message
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
