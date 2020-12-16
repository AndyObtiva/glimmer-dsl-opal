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
require 'glimmer/swt/menu_item_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.Menu
    #
    # Functions differently from other widget proxies.
    #
    # Glimmer automatically detects if this is a drop down menu
    # or pop up menu from its parent if no SWT style is passed in.
    #
    # There are 3 possibilities:
    # - SWT :bar style is passed in: Menu Bar
    # - Parent is ShellProxy: Pop Up Menu (having style :pop_up)
    # - Parent is another Menu: Drop Down Menu (having style :drop_down)
    #
    # In order to get the SWT Menu object, one must call `#swt_widget`.
    #
    # In the case of a Drop Down menu, this automatically creates an
    # SWT MenuItem object with style :cascade
    #
    # In order to retrieve the menu item widget proxy, one must call `#menu_item_proxy`
    #
    # Follows the Proxy Design Pattern
    class MenuProxy < WidgetProxy
      attr_reader :menu_item_proxy, :menu_parent

      def initialize(parent, args)
        # TODO handle :bar swt style
        # TODO handle :pop_up swt style
        # TODO handle :cascade swt style
        @children = []
        index = args.delete(args.last) if args.last.is_a?(Numeric)
        styles = args.map(&:to_sym)
        if !styles.include?(:bar) && !parent.is_a?(MenuProxy)
          styles = styles.unshift(:pop_up)
        end

        if parent.is_a?(MenuProxy)
          @menu_item_proxy = SWT::WidgetProxy.for('menu_item', parent, [:cascade] + [index].compact)
          super(@menu_item_proxy)
          @menu_item_proxy.menu = self
        elsif parent.is_a?(ShellProxy)
          super(parent, style('menu', styles))
        else
          super(parent)
        end

        if styles.include?(:bar)
          # Assumes a parent shell
          parent.menu_bar = self
        elsif styles.include?(:pop_up)
          parent.menu = self
        end
        # TODO IMPLEMENT PROPERLY
#         on_focus_lost {
#           dispose
#         }
      end
      
      def text
        @menu_item_proxy&.text
      end
      
      def text=(text_value)
        @menu_item_proxy&.text = text_value
      end
      
      def can_handle_observation_request?(observation_request, super_only: false)
        super_result = super(observation_request)
        if observation_request.start_with?('on_') && !super_result && !super_only
          return menu_item_proxy.can_handle_observation_request?(observation_request)
        else
          super_result
        end
      end
      
      def handle_observation_request(observation_request, block)
        if can_handle_observation_request?(observation_request, super_only: true)
          super
        else
          menu_item_proxy.handle_observation_request(observation_request, block)
        end
      end
      
      def post_initialize_child(child)
        if child && !@children.include?(child)
          if child.is_a?(MenuItemProxy)
            @children << child
          else
            @children << child.menu_item_proxy
          end
        end
      end
      
      def render
        # TODO attach to top nav bar if parent is shell
        # TODO attach listener to parent to display on right click
        if parent.is_a?(MenuProxy) || parent.is_a?(MenuItemProxy) || parent.menu_requested?
          super
          if root_menu?
            id_css = "##{id}"
            `$(#{id_css}).menu();`
            @close_event_handler = lambda do |event|
              if event.target.parents('.ui-menu').empty?
                close
              end
            end
            Element['body'].on('click', &@close_event_handler)
            @menu_initialized = true
          end
        end
      end
      
      def close
        dom_element.remove
        Element['body'].off('click', &@close_event_handler)
      end
      
      def root_menu?
        !parent.is_a?(MenuProxy) && !parent.is_a?(MenuItemProxy)
      end
      
      def parent_menu
        parent.parent unless root_menu?
      end
      
      def element
        'ul'
      end
      
      def dom
        @dom ||= html {
          ul(id: id, class: name) {
          }
        }.to_s
      end
    end
  end
end
