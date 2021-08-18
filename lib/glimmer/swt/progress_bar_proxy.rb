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

module Glimmer
  module SWT
    class ProgressBarProxy < WidgetProxy
      STYLE = <<~CSS
        .ui-progressbar.vertical {
          transform: rotate(-90deg);
        }
      CSS
      
      attr_reader :vertical, :indeterminate, :maximum, :selection
      attr_accessor :state, :minimum #ignored, only there for API compatibility
      alias vertical? vertical
      alias indeterminate? indeterminate
      
      def initialize(parent, args, block)
        @vertical = args.detect { |arg| SWTProxy[arg] == SWTProxy[:vertical] }
        @indeterminate = args.detect { |arg| SWTProxy[arg] == SWTProxy[:indeterminate] }
        super(parent, args, block)
        dom_element.progressbar
        self.selection = false if indeterminate?
      end
      
      def horizontal
        !vertical
      end
      alias horizontal? horizontal
      
      def maximum=(value)
        @maximum = value
        dom_element.progressbar('option', 'max', @maximum)
      end
      
      def selection=(value)
        @selection = value
        dom_element.progressbar('option', 'value', @selection)
      end

      def element
        'div'
      end
      
      def dom
        progress_bar_id = id
        progress_bar_class = name
        progress_bar_class += ' vertical' if vertical?
        progress_bar_class += ' indeterminate' if indeterminate?
        @dom ||= html {
          div(id: progress_bar_id, class: progress_bar_class)
        }.to_s
      end
    end
  end
end
