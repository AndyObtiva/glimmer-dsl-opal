# Copyright (c) 2007-2021 Andy Maleh
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

require 'glimmer/swt/property_owner'
require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/display_proxy'
require 'glimmer/swt/color_proxy'
require 'glimmer/swt/font_proxy'
# require 'glimmer/swt/transform_proxy'
require 'glimmer/swt/point'
require 'glimmer/swt/rectangle'

module Glimmer
  module SWT
    module Custom
      # Represents a shape (graphics) to be drawn on a control/widget/canvas/display
      # That is because Shape is drawn on a parent as graphics and doesn't have an SWT widget for itself
      class Shape < WidgetProxy
        include PropertyOwner
        
        class << self
          def create(parent, keyword, args, &property_block)
            potential_shape_class_name = keyword.to_s.camelcase(:upper).to_sym
            if constants.include?(potential_shape_class_name)
              const_get(potential_shape_class_name).new(parent, args, &property_block)
            else
              new(parent, args, &property_block)
            end
          end
        
          def valid?(parent, keyword, args, &block)
            return true if keyword.to_s == 'shape'
            keywords.include?(keyword.to_s)
          end
          
          def keywords
            constants.select do |constant|
              constant_value = const_get(constant)
              constant_value.respond_to?(:ancestors) && constant_value.ancestors.include?(Glimmer::SWT::Custom::Shape)
            end.map {|constant| constant.to_s.underscore}
          end
          
        end
        
        def background=(value)
          value = ColorProxy.new(value) if value.is_a?(String)
          @background = value
          dom_element.css('fill', background.to_css) unless background.nil?
        end
        
        def foreground=(value)
          value = ColorProxy.new(value) if value.is_a?(String)
          @foreground = value
          dom_element.css('stroke', foreground.to_css) unless foreground.nil?
          dom_element.css('fill', 'transparent') if background.nil?
        end
        
        def attach(the_parent_dom_element)
          the_parent_dom_element.html("#{the_parent_dom_element.html()}\n#{@dom}")
        end
        
        def element
          'g'
        end
        
        def dom
          shape_id = id
          shape_class = name
          @dom ||= xml {
            g(id: shape_id, class: shape_class) {
            }
          }.to_s
        end
        
      end
      
    end
    
  end
  
end

require 'glimmer/swt/custom/shape/oval'
require 'glimmer/swt/custom/shape/polygon'
require 'glimmer/swt/custom/shape/polyline'
require 'glimmer/swt/custom/shape/rectangle'
require 'glimmer/swt/custom/shape/text'
