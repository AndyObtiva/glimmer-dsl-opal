# Copyright (c) 2020-2021 Andy Maleh
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
require 'glimmer/swt/tab_folder_proxy'

module Glimmer
  module SWT
    class CTabFolderProxy < TabFolderProxy
      OWN_STYLE = <<~CSS
        .extra-tabs-toggle {
          float: right;
          position: relative;
          top: 20px;
        }
        .extra-tabs-toggle > span, .extra-tabs-toggle > sub {
          cursor: pointer;
        }
        .extra-tabs {
          position: absolute;
          left: -130px;
        }
        .extra-tabs a.tab {
          display: block;
          float: none;
          width: 130%;
        }
        .extra-tabs a.tab * {
          display: inline-block;
        }
                
      CSS
      STYLE = OWN_STYLE + TabFolderProxy::STYLE
    
      attr_reader :closeable_children
        
      def initialize(parent, args, block)
        @closeable_children = args.detect { |arg| SWTProxy[:close] == SWTProxy[arg] }
        super(parent, args, block)
      end
          
      def post_initialize_child(child)
        child.closeable = true if @closeable_children
        super(child)
      end
      
      def post_add_content
        Element.find(`window`).on('resize') do |event|
          resize_tabs
        end
        Element['.extra-tabs-toggle > span'].on('click') do |event|
          Element['.extra-tabs'].toggle_class('hide')
        end
      end
      
      def render(custom_parent_dom_element: nil, brand_new: false)
        super(custom_parent_dom_element: custom_parent_dom_element, brand_new: brand_new)
        
      end
      
      def resize_tabs
        Element["##{extra_tabs_id}"].find('a.tab').to_a.reverse.each do |child|
          tabs_dom_element.append child.detach
        end
        while children_width > c_tab_folder_width
          Element["##{extra_tabs_id}"].append tabs_dom_element.find('a.tab').last.detach
        end
      end
      
      def extra_tabs_id
        id + '-extra-tabs'
      end
      
      def extra_tabs_toggle_id
        id + '-extra-tabs-toggle'
      end
      
      def dom
        tab_folder_id = id
        tab_folder_id_style = css
        @dom ||= html {
          div(id: tab_folder_id, style: tab_folder_id_style, class: name) {
            div(id: extra_tabs_toggle_id, class: 'extra-tabs-toggle') {
              span {'»'}
              sub {'3'}
              div(id: extra_tabs_id, class: 'extra-tabs hide') {
              }
            }
            div(id: tabs_id, class: 'tabs') {
            }
          }
        }.to_s
      end
      
      private
      
      def c_tab_folder_width
        tabs_dom_element.outerWidth(true).to_i
      end
      
      def children_width
        tabs_dom_element.children.map { |child| Element[child].outerWidth(true) }.reduce(:+).to_i
      end
      
    end
    
  end
  
end
