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
# require 'glimmer/swt/image_proxy'

module Glimmer
  module SWT
    class LabelProxy < WidgetProxy
      attr_reader :text, :background_image, :image
      
      def initialize(parent, args, block)
        super(parent, args, block)
      end

      def text=(value)
        @text = value
        dom_element.text(@text) # TODO deal with issue of handling lines and escaping at the same time
      end
      
      def html_text
        text&.gsub("\n", '<br />')
      end
      
#       def background_image=(*image_options)
        # TODO consider if there is a difference between background_image and image in label and to have one reuse the other
        # TODO finish implementation
#         @background_image = Glimmer::SWT::ImageProxy.create(*image_options)
#         dom_element.css('background-image', @background_image.image_data.dom_element.src)
#       end
      
      def image=(*image_options)
        # TODO finish implementation
#         @image = Glimmer::SWT::ImageProxy.create(*image_options)
#         dom_element.css('background-image', @image.image_data.dom_element.src)
      end
      
      # background image
      def background_image
        @background_image
      end
      
      # background image is stretched by default
      def background_image=(value)
        @background_image = value
        dom_element.css('background-image', "url(#{background_image})")
        dom_element.css('background-repeat', 'no-repeat')
        dom_element.css('background-size', 'cover')
      end
      
      def element
        'label'
      end
      
      def alignment
        if @alignment.nil?
          found_arg = nil
          @alignment = [:left, :center, :right].detect {|align| found_arg = args.detect { |arg| SWTProxy[align] == SWTProxy[arg] } }
          args.delete(found_arg)
        end
        @alignment
      end

      def alignment=(value)
        # TODO consider storing swt value in the future instead
        @alignment = value
        dom_element.css('text-align', @alignment.to_s)
      end
      
      def dom
        label_id = id
        label_class = name
        @dom ||= html {
          label(id: label_id, class: label_class, style: "text-align: #{alignment};") {
            html_text
          }
        }.to_s
      end
    end
  end
end
