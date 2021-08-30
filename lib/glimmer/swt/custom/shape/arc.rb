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

require 'glimmer/swt/custom/shape'
require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/display_proxy'
require 'glimmer/swt/color_proxy'
# require 'glimmer/swt/transform_proxy'

module Glimmer
  module SWT
    module Custom
      class Shape
        class Arc < Shape

          def render(custom_parent_dom_element: nil, brand_new: false)
            the_parent_element = document.getElementById(parent.id)
            params = { type: Native(`Two`).Types.svg }
            two = Native(`Two`).new(params).appendTo(the_parent_element)
            x = @args[0]
            y = @args[1]
            width = @args[2]
            height = @args[3]
            rx = width / 2.0
            ry = height / 2.0
            cx = x + rx
            cy = y + ry
            # TODO finish implementation connecting args with makeArcSegment method (currently containing static data)
            arc = two.makeArcSegment(150, 150, 0, 35, 2*Math.PI*(-90)/360, 2*Math.PI*(-90 + 77)/360);
          end
                    
        end
      end
    end
  end
end
