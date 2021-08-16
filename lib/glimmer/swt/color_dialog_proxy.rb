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
require 'glimmer/swt/display_proxy'

module Glimmer
  module SWT
    class DialogProxy < CompositeProxy
      STYLE = <<~CSS
        .ui-dialog .ui-dialog-content {
          background: rgb(235, 235, 235);
        }
        .ui-dialog-titlebar {
          background: rgb(80, 116, 211);
          color: white;
        }
        .ui-dialog .dialog .ui-widget-overlay {
          z-index: 10 !important;
          background-color: rgba(0, 0, 0, 0.4);
          opacity: 1;
        }
        .ui-dialog * {
          z-index: 200 !important;
        }
      CSS
      
      attr_accessor :rgb
      
      def initialize(parent, args, block)
        @parent = parent
        @parent = nil if parent.is_a?(LatestShellProxy)
        @parent ||= DisplayProxy.instance.shells.detect(&:open?) || ShellProxy.new([])
        @args = args
        @block = block
        @parent.post_initialize_child(self)
      end
      
      def open?
        @open
      end
      
      def open
        owned_proc = Glimmer::Util::ProcTracker.new(owner: self, invoked_from: :open) {
          shell.open(async: false) unless shell.open?
          unless @init
            dom_element.remove_class('hide')
            dom_element.dialog('auto_open' => false)
            @init = true
            dom_element.dialog('option', 'appendTo', parent.path)
            dom_element.dialog('option', 'modal', true) # NOTE: Not Working! Doing manually below by relying on overlay in ShellProxy.
            unless DisplayProxy.instance.dialogs.any?(&:open?) # only add for first dialog open
              Element['.dialog-overlay'].remove_class('hide')
            end
            dom_element.dialog('option', 'closeOnEscape', true)
            dom_element.dialog('option', 'draggable', true)
            dom_element.dialog('option', 'width', 'auto')
            dom_element.dialog('option', 'minHeight', 'none')
            dom_element.on('dialogclose') do
              unless @hiding
                close
              else
                @hiding = false
              end
            end
          else
            dom_element.dialog('open')
          end
          @open = true
        }
        DisplayProxy.instance.async_exec(owned_proc)
      end
      
      def dom
        @dom ||= html {
          input(id: id, class: "#{name} modal hide", title: text) {
          }
        }.to_s
      end
    end
  end
end

require 'glimmer/dsl/opal/dialog_expression'
