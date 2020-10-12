require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/point'

module Glimmer
  module SWT
    class ShellProxy < CompositeProxy
      # TODO consider renaming to ShellProxy to match SWT API
      attr_reader :minimum_size
    
      WIDTH_MIN = 130
      HEIGHT_MIN = 0
      
      def initialize(args)
        @args = args
        @children = []
#         Document.ready? do end # TODO consider embedding this jQuery call in so outside consumers don't have to use it
        Document.find('body').empty unless ENV['RUBY_ENV'] == 'test'
        render
        @layout = FillLayoutProxy.new(self, [])
        @layout.margin_width = 0
        @layout.margin_height = 0
        self.minimum_size = Point.new(WIDTH_MIN, HEIGHT_MIN)
      end
      
      def element
        'div'
      end
      
      def parent_path
        'body'
      end

      def text
        $document.title
      end

      def text=(value)
        Document.title = value
      end
      
      def minimum_size=(width_or_minimum_size, height = nil)
        @minimum_size = height.nil? ? width_or_minimum_size : Point.new(width_or_minimum_size, height)
        return if @minimum_size.nil?
        dom_element.css('min-width', "#{@minimum_size.x}px")
        dom_element.css('min-height', "#{@minimum_size.y}px")
      end
      
      def style_dom_css
        <<~CSS
          .hide {
            display: none !important;
          }
          .selected, .tabs .tab.selected {
            background: rgb(80, 116, 211);
            color: white;
          }          
        CSS
      end
            
      def style_dom_shell_css
        <<~CSS
          html {
            width: 100%;
            height: 100%;
          }
          body {
            width: 100%;
            height: 100%;
            margin: 0;
          }
          .shell {
            height: 100%;
            margin: 0;
          }
          .shell iframe {
            width: 100%;
            height: 100%;
          }
        CSS
      end
      
      def style_dom_list_css
        <<~CSS
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
        CSS
      end
      
      def style_dom_tab_css
        <<~CSS
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
          .tabs {
            overflow: hidden;
            border: 1px solid #ccc;
            background-color: #f1f1f1;
          }
        CSS
      end
      
      def style_dom_tab_item_css
        <<~CSS
          /* Create an selected/current tablink class */
          .tabs .tab.selected {
            background-color: #ccc;
          }              
          /* Change background color of buttons on hover */
          .tabs .tab:hover {
            background-color: #ddd;
          }              
          /* Style the tab content */
          .tab-item {
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-top: none;
          }
        CSS
      end

      def style_dom_modal_css
        <<~CSS
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
        CSS
      end
      
      def style_dom_table_css
        <<~CSS        
          table {
            border-spacing: 0;
          }
            
          table tr th,td {
            cursor: default;
          }   
        CSS
      end
      
      def dom
        i = 0
        body_id = id
        body_class = ([name] + css_classes.to_a).join(' ')
        @dom ||= html {
          div(id: body_id, class: body_class) {
            style(class: 'common-style') {
              style_dom_css
            }
            style(class: 'shell-style') {
              style_dom_shell_css
            }
            style(class: 'list-style') {
              style_dom_list_css
            }
            style(class: 'tab-style') {
              style_dom_tab_css
            }            
#             style(class: 'tab-item-style') {
#               style_dom_tab_item_css
#             }        
#             style(class: 'modal-style') {
#               style_dom_modal_css
#             }        
            style(class: 'table-style') {            
              style_dom_table_css
            }
            style(class: 'fill-layout-style') {
              Glimmer::SWT::FillLayoutProxy::STYLE
            }
            style(class: 'row-layout-style') {
              Glimmer::SWT::RowLayoutProxy::STYLE
            }
          }
        }.to_s
      end
      
      def open
        # TODO consider the idea of delaying rendering till the open method
        # TODO make it start as hidden and show shell upon open
      end
    end
  end
end
