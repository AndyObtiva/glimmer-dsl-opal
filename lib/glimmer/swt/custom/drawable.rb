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

module Glimmer
  module SWT
    module Custom
      # Represents SWT drawable controls (widgets like canvas) and display
      module Drawable
        attr_accessor :requires_shape_disposal
        alias requires_shape_disposal? requires_shape_disposal
        
        def shapes
          @shapes ||= []
        end
        
        def expanded_shapes
          @shapes.map do |shape|
            [shape] + shape.expanded_shapes
          end.flatten
        end
        
#         def shape_at_location(x, y)
#           expanded_shapes.reverse.detect {|shape| shape.include?(x, y)}
#         end
        
        def add_shape(shape)
          shapes << shape
        end
        
        def clear_shapes(dispose_images: true, dispose_patterns: true)
          # Optimize further by having a collection of disposable_shapes independent of shapes, which is much smaller and only has shapes that require disposal (shapes with patterns or image)
          shapes.dup.each {|s| s.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns) } if requires_shape_disposal?
        end
        alias dispose_shapes clear_shapes
        
        def swt_drawable
          self
        end
        
      end
      
    end
    
  end
  
end
