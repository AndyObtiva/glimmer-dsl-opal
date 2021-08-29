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
        
        SHAPES = %[rectangle]
        
        class << self
          def create(parent, keyword, *args, &property_block)
            potential_shape_class_name = keyword.to_s.camelcase(:upper).to_sym
            if constants.include?(potential_shape_class_name)
              const_get(potential_shape_class_name).new(parent, keyword, *args, &property_block)
            else
              new(parent, keyword, *args, &property_block)
            end
          end
        
          def valid?(parent, keyword, *args, &block)
            return true if keyword.to_s == 'shape'
            keywords.include?(keyword.to_s)
          end
          
          def keywords
            SHAPES
          end
          
          def arg_options(args, extract: false)
            arg_options_method = extract ? :pop : :last
            options = args.send(arg_options_method).symbolize_keys if args.last.is_a?(Hash)
            # normalize :filled option as an alias to :fill
#             options[:fill] = options.delete(:filled) if options&.keys&.include?(:filled)
            options.nil? ? {} : options
          end
          
          def svg_shape_name(keyword, method_arg_options)
            keyword = keyword.to_s
            method_arg_options = method_arg_options.select {|key, value| %w[fill gradient round].include?(key.to_s)}
            unless flyweight_svg_shape_names.keys.include?([keyword, method_arg_options])
              gradient = 'Gradient' if method_arg_options[:gradient]
              round = 'Round' if method_arg_options[:round]
              gc_instance_svg_shape_name_prefix = !['polyline', 'point', 'image', 'focus'].include?(keyword) && (method_arg_options[:fill] || method_arg_options[:gradient]) ? 'fill' : 'draw'
              flyweight_svg_shape_names[[keyword, method_arg_options]] = "#{gc_instance_svg_shape_name_prefix}#{gradient}#{round}#{keyword.capitalize}"
            end
            flyweight_svg_shape_names[[keyword, method_arg_options]]
          end
          
          def flyweight_svg_shape_names
            @flyweight_svg_shape_names ||= {}
          end
          
          def pattern(*args)
            found_pattern = flyweight_patterns[args]
            if found_pattern.nil? || found_pattern.is_disposed
              found_pattern = flyweight_patterns[args] = org.eclipse.swt.graphics.Pattern.new(*args)
            end
            found_pattern
          end
          
          def flyweight_patterns
            @flyweight_patterns ||= {}
          end
          
          # shapes that have defined on_drop expecting to received a dragged shape
          def drop_shapes
            @drop_shapes ||= []
          end
        end
        
        attr_reader :drawable, :parent, :name, :args, :options, :shapes, :properties
        attr_accessor :extent
        
        def initialize(parent, keyword, *args, &property_block)
          @parent = parent
          @drawable = @parent.is_a?(Drawable) ? @parent : @parent.drawable
          @name = keyword
          @options = self.class.arg_options(args, extract: true)
          @svg_shape_name = self.class.svg_shape_name(keyword, @options) unless keyword.to_s == 'shape'
          @args = args
          @properties = {}
          @shapes = [] # nested shapes
          @options.reject {|key, value| %w[fill gradient round].include?(key.to_s)}.each do |property, property_args|
            @properties[property] = property_args
          end
          @parent.add_shape(self)
          post_add_content if property_block.nil?
        end
        
        def add_shape(shape)
          @shapes << shape
          calculated_args_changed_for_defaults!
        end
        
        def draw?
          !fill?
        end
        alias drawn? draw?
        
        def fill?
          @options[:fill]
        end
        alias filled? fill?
        
        def gradient?
          @options[:gradient]
        end
        
        def round?
          @options[:round]
        end
        
        # The bounding box top-left x, y, width, height in absolute positioning
        def bounds
          bounds_dependencies = [absolute_x, absolute_y, calculated_width, calculated_height]
          if bounds_dependencies != @bounds_dependencies
            # avoid repeating calculations
            absolute_x, absolute_y, calculated_width, calculated_height = @bounds_dependencies = bounds_dependencies
            @bounds = Glimmer::SWT::Rectangle.new(absolute_x, absolute_y, calculated_width, calculated_height)
          end
          @bounds
        end
        
        # The bounding box top-left x and y
        def location
          org.eclipse.swt.graphics.Point.new(bounds.x, bounds.y)
        end
        
        # The bounding box width and height (as a Point object with x being width and y being height)
        def size
          size_dependencies = [calculated_width, calculated_height]
          if size_dependencies != @size_dependencies
            # avoid repeating calculations
            calculated_width, calculated_height = @size_dependencies = size_dependencies
            @size = Glimmer::SWT::Point.new(calculated_width, calculated_height)
          end
          @size
        end
        
        def extent
          @extent || size
        end
        
        # Returns if shape contains a point
        # Subclasses (like polygon) may override to indicate if a point x,y coordinates falls inside the shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def contain?(x, y)
          x, y = inverse_transform_point(x, y)
          # assume a rectangular filled shape by default (works for several shapes like image, text, and focus)
          x.between?(self.absolute_x, self.absolute_x + calculated_width.to_f) && y.between?(self.absolute_y, self.absolute_y + calculated_height.to_f)
        end
        
        # Returns if shape includes a point. When the shape is filled, this is the same as contain. When the shape is drawn, it only returns true if the point lies on the edge (boundary/border)
        # Subclasses (like polygon) may override to indicate if a point x,y coordinates falls on the edge of a drawn shape or inside a filled shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def include?(x, y)
          # assume a rectangular shape by default
          contain?(x, y)
        end
        
        def content(&block)
          Glimmer::SWT::DisplayProxy.instance.auto_exec do
            Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::ShapeExpression.new, @name, &block)
            calculated_args_changed!(children: false)
          end
        end
        
        def has_some_background?
          @properties.keys.map(&:to_s).include?('background') || @properties.keys.map(&:to_s).include?('background_pattern')
        end
        
        def has_some_foreground?
          @properties.keys.map(&:to_s).include?('foreground') || @properties.keys.map(&:to_s).include?('foreground_pattern')
        end
        
        def post_add_content
          amend_svg_shape_name_options_based_on_properties!
          if !@content_added || @svg_shape_name != @original_svg_shape_name
            @drawable.setup_shape_painting unless @drawable.is_a?(ImageProxy)
            @content_added = true
          end
        end
        
        def apply_property_arg_conversions(property, args)
          svg_property_name = attribute_setter(property)
          args = args.dup
          the_java_method = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.detect {|m| m.name == svg_property_name}
          return args if the_java_method.nil?
          if the_java_method.parameter_types.first == org.eclipse.swt.graphics.Color.java_class && args.first.is_a?(org.eclipse.swt.graphics.RGB)
            args[0] = [args[0].red, args[0].green, args[0].blue]
          end
          if ['setBackground', 'setForeground'].include?(svg_property_name.to_s) && args.first.is_a?(Array)
            args[0] = ColorProxy.new(args[0])
          end
          if svg_property_name.to_s == 'setLineDash' && args.size > 1
            args[0] = args.dup
            args[1..-1] = []
          end
          if svg_property_name.to_s == 'setAntialias' && [nil, true, false].include?(args.first)
            args[0] = case args.first
            when true
              args[0] = :on
            when false
              args[0] = :off
            when nil
              args[0] = :default
            end
          end
          if args.first.is_a?(Symbol) || args.first.is_a?(::String)
            if the_java_method.parameter_types.first == org.eclipse.swt.graphics.Color.java_class
              args[0] = ColorProxy.new(args[0])
            end
            if svg_property_name.to_s == 'setLineStyle'
              args[0] = "line_#{args[0]}" if !args[0].to_s.downcase.start_with?('line_')
            end
            if svg_property_name.to_s == 'setFillRule'
              args[0] = "fill_#{args[0]}" if !args[0].to_s.downcase.start_with?('fill_')
            end
            if svg_property_name.to_s == 'setLineCap'
              args[0] = "cap_#{args[0]}" if !args[0].to_s.downcase.start_with?('cap_')
            end
            if svg_property_name.to_s == 'setLineJoin'
              args[0] = "join_#{args[0]}" if !args[0].to_s.downcase.start_with?('join_')
            end
            if the_java_method.parameter_types.first == Java::int.java_class
              args[0] = SWTProxy.constant(args[0])
            end
          end
          if args.first.is_a?(ColorProxy)
            args[0] = args[0].swt_color
          end
          if (args.first.is_a?(Hash) || args.first.is_a?(org.eclipse.swt.graphics.FontData)) && the_java_method.parameter_types.first == org.eclipse.swt.graphics.Font.java_class
            args[0] = FontProxy.new(args[0])
          end
          if args.first.is_a?(FontProxy)
            args[0] = args[0].swt_font
          end
          if args.first.is_a?(TransformProxy)
            args[0] = args[0].swt_transform
          end
          if ['setBackgroundPattern', 'setForegroundPattern'].include?(svg_property_name.to_s)
            @drawable.requires_shape_disposal = true
            args = args.first if args.first.is_a?(Array)
            args.each_with_index do |arg, i|
              arg = ColorProxy.new(arg.red, arg.green, arg.blue) if arg.is_a?(org.eclipse.swt.graphics.RGB)
              arg = ColorProxy.new(arg) if arg.is_a?(Symbol) || arg.is_a?(::String)
              arg = arg.swt_color if arg.is_a?(ColorProxy)
              args[i] = arg
            end
            @pattern_args ||= {}
            pattern_type = svg_property_name.to_s.match(/set(.+)Pattern/)[1]
            if args.first.is_a?(org.eclipse.swt.graphics.Pattern)
              new_args = @pattern_args[pattern_type]
            else
              new_args = args.first.is_a?(org.eclipse.swt.widgets.Display) ? args : ([DisplayProxy.instance.swt_display] + args)
              @pattern_args[pattern_type] = new_args.dup
            end
            args[0] = pattern(*new_args, type: pattern_type)
            args[1..-1] = []
          end
          args
        end
        
        def apply_shape_arg_conversions!
          if @args.size > 1 && (['polygon', 'polyline'].include?(@name))
            @args[0] = @args.dup
            @args[1..-1] = []
          end
          if @name == 'image'
            if @args.first.is_a?(::String)
              @args[0] = ImageProxy.create(@args[0])
            end
            if @args.first.is_a?(ImageProxy)
              @image = @args[0] = @args[0].swt_image
            end
            if @args.first.nil?
              @image = nil
            end
          end
          if @name == 'text'
            if @args[3].is_a?(Symbol) || @args[3].is_a?(::String)
              @args[3] = [@args[3]]
            end
            if @args[3].is_a?(Array)
              if @args[3].size == 1 && @args[3].first.is_a?(Array)
                @args[3] = @args[3].first
              end
              @args[3] = SWTProxy[*@args[3]]
            end
          end
        end
        
        def apply_shape_arg_defaults!
          if current_parameter_name?(:dest_x) && dest_x.nil?
            self.dest_x = :default
          elsif parameter_name?(:x) && x.nil?
            self.x = :default
          end
          if current_parameter_name?(:dest_y) && dest_y.nil?
            self.dest_y = :default
          elsif parameter_name?(:y) && y.nil?
            self.y = :default
          end
          self.width = :default if current_parameter_name?(:width) && width.nil?
          self.height = :default if current_parameter_name?(:height) && height.nil?
          if @name.include?('rectangle') && round? && @args.size.between?(4, 5)
            (6 - @args.size).times {@args << 60}
          elsif @name.include?('rectangle') && gradient? && @args.size == 4
            set_attribute('vertical', true, redraw: false)
          elsif (@name.include?('text') || @name.include?('string')) && !@properties.keys.map(&:to_s).include?('background') && @args.size < 4
            set_attribute('is_transparent', true, redraw: false)
          end
          if @name.include?('image')
            @drawable.requires_shape_disposal = true
          end
        end
                
        # Tolerates shape extra args added by user by mistake
        # (e.g. happens when switching from round rectangle to a standard one without removing all extra args)
        def tolerate_shape_extra_args!
          the_java_method_arg_count = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.select do |m|
            m.name == @svg_shape_name.camelcase(:lower)
          end.map(&:parameter_types).map(&:size).max
          if the_java_method_arg_count && @args.to_a.size > the_java_method_arg_count
            @args[the_java_method_arg_count..-1] = []
          end
        end
        
        def amend_svg_shape_name_options_based_on_properties!
          @original_svg_shape_name = @svg_shape_name
          return if @name == 'point'
          if (@name != 'text' && @name != 'string' && has_some_background? && !has_some_foreground?) || (@name == 'path' && has_some_background?)
            @options[:fill] = true
          elsif !has_some_background? && has_some_foreground?
            @options[:fill] = false
          elsif @name == 'rectangle' && has_some_background? && has_some_foreground?
            @options[:fill] = true
            @options[:gradient] = true
          end
          if @name == 'rectangle' && @args.size > 4 && @args.last.is_a?(Numeric)
            @options[:round] = true
          end
          @svg_shape_name = self.class.svg_shape_name(@name, @options)
        end
        
        # parameter names for arguments to pass to SWT GC.xyz method for rendering shape (e.g. draw_image(image, x, y) yields :image, :x, :y parameter names)
        def parameter_names
          [:x, :y, :width, :height]
        end
        
        # subclasses may override to specify location parameter names if different from x and y (e.g. all polygon points are location parameters)
        # used in calculating movement changes
        def location_parameter_names
          [:x, :y]
        end
        
        def possible_parameter_names
          parameter_names
        end
        
        def parameter_name?(attribute_name)
          possible_parameter_names.map(&:to_s).include?(ruby_attribute_getter(attribute_name))
        end
        
        def current_parameter_name?(attribute_name)
          parameter_names.include?(attribute_name.to_s.to_sym)
        end
        
        def parameter_index(attribute_name)
          parameter_names.index(attribute_name.to_s.to_sym)
        end
        
        def get_parameter_attribute(attribute_name)
          @args[parameter_index(ruby_attribute_getter(attribute_name))]
        end
        
        def set_parameter_attribute(attribute_name, *args)
          @args[parameter_index(ruby_attribute_getter(attribute_name))] = args.size == 1 ? args.first : args
        end
        
        def has_attribute?(attribute_name, *args)
          self.class.gc_instance_methods.include?(attribute_setter(attribute_name)) or
            parameter_name?(attribute_name) or
            (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter(attribute_name), super: true))
        end
        
        def set_attribute(attribute_name, *args)
          options = args.last if args.last.is_a?(Hash)
          args.pop if !options.nil? && !options[:redraw].nil?
          options ||= {}
          perform_redraw = @perform_redraw
          perform_redraw = options[:redraw] if perform_redraw.nil? && !options.nil?
          perform_redraw ||= true
          property_change = nil
          ruby_attribute_getter_name = ruby_attribute_getter(attribute_name)
          ruby_attribute_setter_name = ruby_attribute_setter(attribute_name)
          if parameter_name?(attribute_name)
            return if ruby_attribute_getter_name == (args.size == 1 ? args.first : args)
            set_parameter_attribute(ruby_attribute_getter_name, *args)
          elsif (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter_name, super: true))
            return if self.send(ruby_attribute_getter_name) == (args.size == 1 ? args.first : args)
            self.send(ruby_attribute_setter_name, *args)
          else
            # TODO consider this optimization of preconverting args (removing conversion from other methods) to reject equal args
            args = apply_property_arg_conversions(ruby_attribute_getter_name, args)
            return if @properties[ruby_attribute_getter_name] == args
            new_property = !@properties.keys.include?(ruby_attribute_getter_name)
            @properties[ruby_attribute_getter_name] = args
            amend_svg_shape_name_options_based_on_properties! if @content_added && new_property
            property_change = true
            calculated_paint_args_changed! if container?
          end
          if @content_added && perform_redraw && !drawable.is_disposed
            redrawn = false
            unless property_change
              calculated_paint_args_changed!(children: false)
              if is_a?(PathSegment)
                root_path&.calculated_path_args = @calculated_path_args = false
                calculated_args_changed!
                root_path&.calculated_args_changed!
              end
              if location_parameter_names.map(&:to_s).include?(ruby_attribute_getter_name)
                calculated_args_changed!(children: true)
                redrawn = parent.calculated_args_changed_for_defaults! if parent.is_a?(Shape)
              end
              if ['width', 'height'].include?(ruby_attribute_getter_name)
                redrawn = calculated_args_changed_for_defaults!
              end
            end
            # TODO consider redrawing an image proxy's gc in the future
            # TODO consider ensuring only a single redraw happens for a hierarchy of nested shapes
#             drawable.redraw if !redrawn && !drawable.is_a?(ImageProxy)
          end
        end
        
        def get_attribute(attribute_name)
          if parameter_name?(attribute_name)
            arg_index = parameter_index(attribute_name)
            @args[arg_index] if arg_index
          elsif (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter(attribute_name), super: true))
            self.send(attribute_name)
          else
            @properties[attribute_name.to_s]
          end
        end
        
        def can_handle_observation_request?(observation_request)
          drawable.can_handle_observation_request?(observation_request)
        end
        
        def handle_observation_request(observation_request, &block)
          shape_block = lambda do |event|
            block.call(event) if include_with_children?(event.x, event.y)
          end
          if observation_request == 'on_drop'
            Shape.drop_shapes << self
            handle_observation_request('on_mouse_up') do |event|
              if Shape.dragging && include_with_children?(event.x, event.y, except_child: Shape.dragged_shape)
                drop_event = DropEvent.new(
                  doit: true,
                  dragged_shape: Shape.dragged_shape,
                  dragged_shape_original_x: Shape.dragged_shape_original_x,
                  dragged_shape_original_y: Shape.dragged_shape_original_y,
                  dragging_x: Shape.dragging_x,
                  dragging_y: Shape.dragging_y,
                  drop_shapes: Shape.drop_shapes,
                  x: event.x,
                  y: event.y
                )
                begin
                  block.call(drop_event)
                rescue => e
                  Glimmer::Config.logger.error e.full_message
                ensure
                  Shape.dragging = false
                  if !drop_event.doit && Shape.dragged_shape
                    Shape.dragged_shape.x = Shape.dragged_shape_original_x
                    Shape.dragged_shape.y = Shape.dragged_shape_original_y
                  end
                  Shape.dragged_shape = nil
                end
              end
            end
          else
            drawable.handle_observation_request(observation_request, &shape_block)
          end
        end
        
        # Sets data just like SWT widgets
        def set_data(key=nil, value)
          @data ||= {}
          @data[key] = value
        end
        alias setData set_data # for compatibility with SWT APIs
  
        # Gets data just like SWT widgets
        def get_data(key=nil)
          @data ||= {}
          @data[key]
        end
        alias getData get_data # for compatibility with SWT APIs
        alias data get_data # for compatibility with SWT APIs
  
        def method_missing(method_name, *args, &block)
          if method_name.to_s.end_with?('=')
            set_attribute(method_name, *args)
          elsif has_attribute?(method_name)
            get_attribute(method_name)
          else # TODO support proxying calls to handle_observation_request for listeners just like WidgetProxy
            super
          end
        end
        
        def respond_to?(method_name, *args, &block)
          options = args.last if args.last.is_a?(Hash)
          super_invocation = options && options[:super]
          if !super_invocation && has_attribute?(method_name)
            true
          else
            super
          end
        end
          
        def pattern(*args, type: nil)
          instance_variable_name = "@#{type}_pattern"
          the_pattern = instance_variable_get(instance_variable_name)
          if the_pattern.nil? || the_pattern.is_disposed
            the_pattern = self.class.pattern(*args)
          end
          the_pattern
        end
        
        def pattern_args(type: nil)
          @pattern_args && @pattern_args[type.to_s.capitalize]
        end
        
        def background_pattern_args
          pattern_args(type: 'background')
        end
        
        def foreground_pattern_args
          pattern_args(type: 'foreground')
        end
        
        def dispose(dispose_images: true, dispose_patterns: true, redraw: true)
          shapes.each { |shape| shape.is_a?(Shape::Path) && shape.dispose } # TODO look into why I'm only disposing paths
          if dispose_patterns
            @background_pattern&.dispose
            @background_pattern = nil
            @foreground_pattern&.dispose
            @foreground_pattern = nil
          end
          if dispose_images
            @image&.dispose
            @image = nil
          end
          @parent.shapes.delete(self)
          drawable.redraw if redraw && !drawable.is_a?(ImageProxy)
        end
        
        # clear all shapes
        # indicate whether to dispose images, dispose patterns, and redraw after clearing shapes.
        # redraw can be `:all` or `true` to mean redraw after all shapes are disposed, `:each` to mean redraw after each shape is disposed, or `false` to avoid redraw altogether
        def clear_shapes(dispose_images: true, dispose_patterns: true, redraw: :all)
          if redraw == true || redraw == :all
            shapes.dup.each {|shape| shape.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns, redraw: false) }
            drawable.redraw if redraw && !drawable.is_a?(ImageProxy)
          elsif redraw == :each
            shapes.dup.each {|shape| shape.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns, redraw: true) }
          else
            shapes.dup.each {|shape| shape.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns, redraw: false) }
          end
        end
        alias dispose_shapes clear_shapes
        
        # Indicate if this is a container shape (meaning a shape bag that is just there to contain nested shapes, but doesn't render anything of its own)
        def container?
          @name == 'shape'
        end
        
        # Indicate if this is a composite shape (meaning a shape that contains nested shapes like a rectangle with ovals inside it)
        def composite?
          !shapes.empty?
        end
        
        # ordered from closest to farthest parent
        def parent_shapes
          if @parent_shapes.nil?
            if parent.is_a?(Drawable)
              @parent_shapes = []
            else
              @parent_shapes = parent.parent_shapes + [parent]
            end
          end
          @parent_shapes
        end
        
        # ordered from closest to farthest parent
        def parent_shape_containers
          if @parent_shape_containers.nil?
            if parent.is_a?(Drawable)
              @parent_shape_containers = []
            elsif !parent.container?
              @parent_shape_containers = parent.parent_shape_containers
            else
              @parent_shape_containers = parent.parent_shape_containers + [parent]
            end
          end
          @parent_shape_containers
        end
        
        # ordered from closest to farthest parent
        def parent_shape_composites
          if @parent_shape_composites.nil?
            if parent.is_a?(Drawable)
              @parent_shape_composites = []
            elsif !parent.container?
              @parent_shape_composites = parent.parent_shape_composites
            else
              @parent_shape_composites = parent.parent_shape_composites + [parent]
            end
          end
          @parent_shape_composites
        end
        
        def convert_properties!
          if @properties != @converted_properties
            @properties.each do |property, args|
              @properties[property] = apply_property_arg_conversions(property, args)
            end
            @converted_properties = @properties.dup
          end
        end
        
        def converted_properties
          convert_properties!
          @properties
        end
        
        def all_parent_properties
          @all_parent_properties ||= parent_shape_containers.reverse.reduce({}) do |all_properties, parent_shape|
            all_properties.merge(parent_shape.converted_properties)
          end
        end
        
        def paint(paint_event)
          paint_children(paint_event) if default_width? || default_height?
          paint_self(paint_event)
          # re-paint children from scratch in the special case of pre-calculating parent width/height to re-center within new parent dimensions
          shapes.each(&:calculated_args_changed!) if default_width? || default_height?
          paint_children(paint_event)
        rescue => e
          Glimmer::Config.logger.error {"Error encountered in painting shape (#{self.inspect}) with calculated args (#{@calculated_args}) and args (#{@args})"}
          Glimmer::Config.logger.error {e.full_message}
        end
        
        def paint_self(paint_event)
          @painting = true
          unless container?
            calculate_paint_args!
            @original_gc_properties = {} # this stores GC properties before making calls to updates TODO avoid using in pixel graphics
            @properties.each do |property, args|
              svg_property_name = attribute_setter(property)
              @original_gc_properties[svg_property_name] = paint_event.gc.send(svg_property_name.sub('set', 'get')) rescue nil
              paint_event.gc.send(svg_property_name, *args)
              if property == 'transform' && args.first.is_a?(TransformProxy)
                args.first.swt_transform.dispose
              end
            end
            ensure_extent(paint_event)
          end
          @calculated_args ||= calculate_args!
          unless container?
            # paint unless parent's calculated args are not calculated yet, meaning it is about to get painted and trigger a paint on this child anyways
            paint_event.gc.send(@svg_shape_name, *@calculated_args) unless (parent.is_a?(Shape) && !parent.calculated_args?)
            @original_gc_properties.each do |svg_shape_name, value|
              paint_event.gc.send(svg_shape_name, value)
            end
          end
          @painting = false
        rescue => e
          Glimmer::Config.logger.error {"Error encountered in painting shape (#{self.inspect}) with method (#{@svg_shape_name}) calculated args (#{@calculated_args}) and args (#{@args})"}
          Glimmer::Config.logger.error {e.full_message}
        ensure
          @painting = false
        end
        
        def paint_children(paint_event)
          shapes.to_a.each do |shape|
            shape.paint(paint_event)
          end
        end
        
        def ensure_extent(paint_event)
          old_extent = @extent
          if ['text', 'string'].include?(@name)
            extent_args = [string]
            extent_flags = SWTProxy[:draw_transparent] if current_parameter_name?(:is_transparent) && is_transparent
            extent_flags = flags if current_parameter_name?(:flags)
            extent_args << extent_flags unless extent_flags.nil?
            self.extent = paint_event.gc.send("#{@name}Extent", *extent_args)
          end
          if !@extent.nil? && (old_extent&.x != @extent&.x || old_extent&.y != @extent&.y) # TODO add a check to text content changing too
            calculated_args_changed!
            parent.calculated_args_changed_for_defaults! if parent.is_a?(Shape)
          end
        end
        
        def expanded_shapes
          if shapes.to_a.any?
            shapes.map do |shape|
              [shape] + shape.expanded_shapes
            end.flatten
          else
            []
          end
        end
        
        def calculated_args_changed!(children: true)
          # TODO add a children: true option to enable setting to false to avoid recalculating children args
          @calculated_args = nil
          shapes.each(&:calculated_args_changed!) if children
        end
        
        def calculated_paint_args_changed!(children: true)
          @calculated_paint_args = nil
          @all_parent_properties = nil
          shapes.each(&:calculated_paint_args_changed!) if children
        end
        
        # Notifies object that calculated args changed for defaults. Returns true if redrawing and false otherwise.
        def calculated_args_changed_for_defaults!
          has_default_dimensions = default_width? || default_height?
          parent_calculated_args_changed_for_defaults = has_default_dimensions
          calculated_args_changed!(children: false) if default_x? || default_y? || has_default_dimensions
          if has_default_dimensions && parent.is_a?(Shape)
            parent.calculated_args_changed_for_defaults!
          elsif @content_added && !drawable.is_disposed
            # TODO consider optimizing in the future if needed by ensuring one redraw for all parents in the hierarchy at the end instead of doing one per parent that needs it
            if !@painting && !drawable.is_a?(ImageProxy)
              drawable.redraw
              return true
            end
          end
          false
        end
        
        # Overriding inspect to avoid printing very long nested shape hierarchies (recurses onces only)
        def inspect(recursive: 1, calculated: false, args: true, properties: true, calculated_args: false)
          recurse = recursive == true || recursive.is_a?(Integer) && recursive.to_i > 0
          recursive = [recursive -= 1, 0].max if recursive.is_a?(Integer)
          args_string = " args=#{@args.inspect}" if args
          properties_string = " properties=#{@properties.inspect}}" if properties
          calculated_args_string = " calculated_args=#{@calculated_args.inspect}" if calculated_args
          calculated_string = " absolute_x=#{absolute_x} absolute_y=#{absolute_y} calculated_width=#{calculated_width} calculated_height=#{calculated_height}" if calculated
          recursive_string = " shapes=#{@shapes.map {|s| s.inspect(recursive: recursive, calculated: calculated, args: args, properties: properties)}}" if recurse
          "#<#{self.class.name}:0x#{self.hash.to_s(16)}#{args_string}#{properties_string}#{calculated_args_string}#{calculated_string}#{recursive_string}>"
        rescue => e
          Glimmer::Config.logger.error { e.full_message }
          "#<#{self.class.name}:0x#{self.hash.to_s(16)}"
        end
        
        def calculate_paint_args!
          unless @calculated_paint_args
            if @name == 'pixel'
              @name = 'point'
              # optimized performance calculation for pixel points
              if !@properties[:foreground].is_a?(org.eclipse.swt.graphics.Color)
                if @properties[:foreground].is_a?(Array)
                  @properties[:foreground] = ColorProxy.new(@properties[:foreground], ensure_bounds: false)
                end
                if @properties[:foreground].is_a?(Symbol) || @properties[:foreground].is_a?(::String)
                 @properties[:foreground] = ColorProxy.new(@properties[:foreground], ensure_bounds: false)
                end
                if @properties[:foreground].is_a?(ColorProxy)
                  @properties[:foreground] = @properties[:foreground].swt_color
                end
              end
            else
              @original_properties ||= @properties
              @properties = all_parent_properties.merge(@original_properties)
              @properties['background'] = [@drawable.background] if fill? && !has_some_background?
              @properties['foreground'] = [@drawable.foreground] if @drawable.respond_to?(:foreground) && draw? && !has_some_foreground?
              # TODO regarding alpha, make sure to reset it to parent stored alpha once we allow setting shape properties on parents directly without shapes
              @properties['font'] = [@drawable.font] if @drawable.respond_to?(:font) && @name == 'text' && draw? && !@properties.keys.map(&:to_s).include?('font')
              # TODO regarding transform, make sure to reset it to parent stored transform once we allow setting shape properties on parents directly without shapes
              # Also do that with all future-added properties
              convert_properties!
              apply_shape_arg_conversions!
              apply_shape_arg_defaults!
              tolerate_shape_extra_args!
              @calculated_paint_args = true
            end
          end
        end
    
      end
      
    end
    
  end
  
end

require 'glimmer/swt/custom/shape/rectangle'
