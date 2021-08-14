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

require 'glimmer/swt/tab_item_proxy'

module Glimmer
  module SWT
    class CTabItemProxy < TabItemProxy
      attr_reader :selection_foreground
      
      def initialize(parent, args, block)
        super(parent, args, block)
        # TODO do something with :close style if set
      end
      
      def foreground=(value)
        value = ColorProxy.new(value) if value.is_a?(String)
        @foreground = value
        tab_dom_element.css('color', foreground.to_css) unless foreground.nil?
      end
      
      def selection_foreground=(value)
        value = ColorProxy.new(value) if value.is_a?(String)
        @selection_foreground = value
        if @selection_foreground && tab_dom_element.has_class?('selected')
          @old_foreground = tab_dom_element.css('color')
          tab_dom_element.css('color', @selection_foreground.to_css)
        end
      end
      
      def font=(value)
        @font = value.is_a?(FontProxy) ? value : FontProxy.new(self, value)
        tab_dom_element.css('font-family', @font.name) unless @font.nil?
        tab_dom_element.css('font-style', 'italic') if @font&.style == :italic || @font&.style&.to_a&.include?(:italic)
        tab_dom_element.css('font-weight', 'bold') if @font&.style == :bold || @font&.style&.to_a&.include?(:bold)
        tab_dom_element.css('font-size', "#{@font.height}px") unless @font.nil?
      end
      
      def show
        super
        if @selection_foreground
          @old_foreground = tab_dom_element.css('color')
          tab_dom_element.css('color', @selection_foreground.to_css)
        end
      end
      
      def hide
        super
        if @old_foreground
          tab_dom_element.css('color', @old_foreground)
          @old_foreground = nil
        end
      end
      
    end
  end
end
