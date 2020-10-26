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

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.graphics.ImageData to use in Glimmer DSL for Opal
    #
    # Follows the Adapter Design Pattern
    class ImageData
      attr_reader :filename
      
      def initialize(filename)
        @filename = filename        
      end
      
      def dom_element
        if @dom_element.nil?
          pd @dom_element = Element.new(:img)
          pd @filename
          File.open(@filename, 'rb') do |img|
            pd the_img = img.read
            @dom_element.src = 'data:image/png;base64,' + Base64.strict_encode64(the_img)
          end
        end
        @dom_element
      end
      
      def width
        dom_element.prop('width')
      end
      
      def height
        dom_element.prop('height')
      end
      
      def scaledTo(width, height)
      
      end
    end
  end
end
