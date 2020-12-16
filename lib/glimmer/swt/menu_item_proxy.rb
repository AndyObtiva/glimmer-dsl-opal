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

# TODO implement set_menu or self.menu=

require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.MenuItem
    #
    # Follows the Proxy Design Pattern since it's a proxy for an HTML based menu
    # Follows the Adapter Design Pattern since it's adapting a Glimmer DSL for SWT widget
    class MenuItemProxy < WidgetProxy
      def post_initialize_child(child)
        @children << child
      end
      
      def text
        @text
      end
      
      def text=(value)
        @text = value
        dom_element.html(html {div {value}}.to_s)
        @text
      end
      
      def root_menu
        the_menu = parent
        the_menu = the_menu.parent_menu until the_menu.root_menu?
        the_menu
      end
      
      def skip_content_on_render_blocks?
        true
      end
      
      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'mouseup',
            event_handler: -> (event_listener) {
              -> (event) {
                remove_event_listener_proxies
                root_menu.close
                event_listener.call(event)
              }
            },
          },
        }
      end
      
      def element
        'li'
      end
      
      def dom
        @dom ||= html {
          li(id: id, class: name) {
            div {
              @text
            }
          }
        }.to_s
      end
    end
  end
end
