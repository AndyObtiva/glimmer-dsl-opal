require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/point'

module Glimmer
  module SWT
    class ShellProxy < WidgetProxy
      # TODO consider renaming to ShellProxy to match SWT API
      attr_reader :minimum_size
    
      def initialize(args)
        @args = args
        @children = []
        $document.ready do
          $document.body << dom
        end
      end

      def text
        $document.title
      end

      def text=(value)
        $document.ready do
          $document.title = value
        end
      end
      
      def minimum_size=(width_or_minimum_size, height = nil)
        @minimum_size = height.nil? ? width_or_minimum_size : Point.new(width_or_minimum_size, height)
        redraw
      end
      
      def head_style_css
        <<~CSS
          <style>
            html {
              width: 100%;
              height: 100%;
            }
            body {
              width: 100%;
              height: 100%;
              margin: 0;
            }
            body > iframe {
              width: 100%;
              height: 100%;
            }
            ul {
              list-style: none;
              padding: 0;
            }
            li {
              cursor: default;
              padding-left: 10px;
              padding-right: 10px;
            }
            li.empty-list-item {
              color: transparent;
            }
            .tabs {
              overflow: hidden;
              border: 1px solid #ccc;
              background-color: #f1f1f1;
            }
            
            /* Style the buttons inside the tab */
            .tabs .tab {
              background-color: inherit;
              float: left;
              border: none;
              outline: none;
              cursor: pointer;
              padding: 14px 16px;
              transition: 0.3s;
              font-size: 17px;
            }
            
            /* Change background color of buttons on hover */
            .tabs .tab:hover {
              background-color: #ddd;
            }
            
            /* Create an active/current tablink class */
            .tabs .tab.active {
              background-color: #ccc;
            }
            
            /* Style the tab content */
            .tab-item {
              padding: 6px 12px;
              border: 1px solid #ccc;
              border-top: none;
            }
            
            .hide {
              display: none !important;
            }
                          
            /* The Modal (background) */
            .modal {
              position: fixed; /* Stay in place */
              z-index: 1; /* Sit on top */
              padding-top: 100px; /* Location of the box */
              left: 0;
              top: 0;
              width: 100%; /* Full width */
              height: 100%; /* Full height */
              overflow: auto; /* Enable scroll if needed */
              background-color: rgb(0,0,0); /* Fallback color */
              background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
              text-align: center;
            }
            
            /* Modal Content */
            .modal-content {
              background-color: #fefefe;
              margin: auto;
              border: 1px solid #888;
              display: inline-block;
              min-width: 200px;
            }
            
            .modal-content .text {
              background: rgb(80, 116, 211);
              color: white;
              padding: 5px;
            }
            
            .modal-content .message {
              padding: 20px;
            }
            
            /* The Close Button */
            .close {
              color: #aaaaaa;
              float: right;
              font-weight: bold;
              margin: 5px;
            }
            
            .close:hover,
            .close:focus {
              color: #000;
              text-decoration: none;
              cursor: pointer;
            }
            
            .selected {
              background: rgb(80, 116, 211);
              color: white;
            }
            
            table {
              border-spacing: 0;
            }
            
            table tr th,td {
              cursor: default;
            }
  
          </style>
        CSS
      end
      
      def head_dom
        head_dom_css = head_style_css
        # TODO make grid-layout support grab excess space false
        @head_dom ||= DOM {
          div(class: 'shell-style') {
            head_dom_css
          }
        }
      end
      
      def dom
        i = 0
        body_id = id
        body_style = '' # a start for more styling further along
        body_style += "min-width: #{@minimum_size.x}px; min-height: #{@minimum_size.y}px;" if @minimum_size
        @dom ||= DOM {
          div(id: body_id, class: 'shell', style: body_style) {                    
          }
        }.tap { |the_dom| the_dom >> head_dom }
      end
      
      def open
        # No Op (just a placeholder since it is not needed on the web)
      end
    end
  end
end
