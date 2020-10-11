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

require 'glimmer/swt/event_listener_proxy'
require 'glimmer/swt/property_owner'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module SWT
    class WidgetProxy
      include Glimmer
      include PropertyOwner
      
      attr_reader :parent, :args, :path, :children, :enabled, :foreground, :background, :font
      
      class << self
        # Factory Method that translates a Glimmer DSL keyword into a WidgetProxy object
        def for(keyword, parent, args)
          the_widget_class = widget_class(keyword)
          the_widget_class.new(parent, args)
        end
        
        def widget_class(keyword)
          class_name_alternative = keyword.camelcase(:upper)
          class_name_main = "#{class_name_alternative}Proxy"
          Glimmer::SWT.const_get(class_name_main.to_sym) rescue Glimmer::SWT.const_get(class_name_alternative.to_sym)
        rescue => e
          puts "Widget #{keyword} was not found!"
          nil
        end
        
        def widget_exists?(keyword)
          !!widget_class(keyword)
        end
      
        def next_id_number_for(name)
          @max_id_numbers[name] = max_id_number_for(name) + 1
        end
        
        def max_id_number_for(name)
          @max_id_numbers[name] = max_id_numbers[name] || 0
        end
        
        def max_id_numbers
          @max_id_numbers ||= reset_max_id_numbers!
        end
        
        def reset_max_id_numbers!
          @max_id_numbers = {}
        end
      end
      
      def initialize(parent, args)
        @parent = parent        
        @args = args
        @children = Set.new
        @enabled = true
        @parent.add_child(self)
      end
      
      def css_classes
        # TODO consider deprecating this in favor of jquery css class setting on dom directly if practical
        @css_classes ||= Set.new      
      end      
      
      def dispose
        Document.find(path).remove
      end
      
      def path
        "#{parent_path} > #{element}##{id}.#{name}"
      end

      # Root element representing widget. Must be overridden by subclasses if different from div
      def element
        'div'
      end

      def add_child(child)
        @children << child
        child.redraw
      end
      
      def enabled=(value)
        @enabled = value
        # TODO consider relying less on redraw in setters in the future
        redraw
      end
      
      def foreground=(value)
        @foreground = value
        dom_element.css('color', foreground.to_css) unless foreground.nil?
      end
      
      def background=(value)
        @background = value
        dom_element.css('background-color', background.to_css) unless background.nil?
      end
      
      def font=(value)
        @font = value.is_a?(FontProxy) ? value : FontProxy.new(self, value)
        dom_element.css('font-family', @font.name) unless @font.nil?
        dom_element.css('font-style', 'italic') if @font&.style == :italic
        dom_element.css('font-weight', 'bold') if @font&.style == :bold
        dom_element.css('font-size', "#{@font.height}px") unless @font.nil?
      end
      
      def parent_path
        @parent.path
      end

      def redraw
        if @dom && !Document.find(path).empty?
          old_element = Document.find(path)
          old_dom = @dom
          @dom = nil
          @dom = dom
          @dom = @parent.layout.dom(@dom) if @parent.respond_to?(:layout) && @parent.layout
          old_element.replace_with(@dom.gsub('<html>', '').gsub('</html>', ''))
        else
          @dom = nil
          @dom = dom
          @dom = @parent.layout.dom(@dom) if @parent.respond_to?(:layout) && @parent.layout
          Document.find(parent_path).append(@dom.gsub('<html>', '').gsub('</html>', ''))
        end
        @observation_requests&.clone&.each do |keyword, event_listener_set|
          event_listener_set.each do |event_listener|
            @observation_requests[keyword].delete(event_listener)
            handle_observation_request(keyword, &event_listener)
          end
        end
        children.each do |child|
          child.redraw
        end
      end
      
      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::Opal::WidgetExpression.new, &block)
      end
      
      # Subclasses must override with their own mappings
      def observation_request_to_event_mapping
        {}
      end
      
      def name
        self.class.name.split('::').last.underscore.sub(/_proxy$/, '').gsub('_', '-')
      end
      
      def id
        @id ||= "#{name}-#{WidgetProxy.next_id_number_for(name)}"
      end
            
      # Sets id explicitly. Useful in cases of wanting to maintain a stable id
      def id=(value)
        @id = value
      end
            
      # Subclasses can override with their own selector
      def selector
        "#{name}##{id}"
      end
      
      def add_css_class(css_class)
        css_classes << css_class
        redraw
      end
      
      def add_css_classes(css_classes)
        css_classes += css_classes
        redraw
      end
      
      def remove_css_class(css_class)
        css_classes.delete(css_class)
        redraw
      end
      
      def remove_css_classes(css_classes)
        css_classes -= css_classes
        redraw
      end
      
      def clear_css_classes(css_class)
        css_classes.clear
        redraw
      end
      
      def has_style?(symbol)
        @args.include?(symbol) # not a very solid implementation. Bring SWT constants eventually
      end
      
      def dom_element
        Document.find(path)
      end
      
      def style_element
        style_element_id = "#{id}-style"
        style_element_selector = "style##{style_element_id}"
        element = dom_element.find(style_element_selector)
        if element.empty?
          new_element = Element.new(:style)
          new_element.attr('id', style_element_id)
          new_element.attr('class', "#{name.gsub('_', '-')}-instance-style widget-instance-style")
          dom_element.prepend(new_element)
          element = dom_element.find(style_element_selector)
        end
        element
      end
      
      def parent_dom_element
        Document.find(parent_path)
      end
      
      def listener_path
        path
      end
      
      def can_handle_observation_request?(observation_request)        
        # TODO sort this out for Opal
        observation_request = observation_request.to_s
        if observation_request.start_with?('on_swt_')
          constant_name = observation_request.sub(/^on_swt_/, '')
          SWTProxy.has_constant?(constant_name)
        elsif observation_request.start_with?('on_')
#           event = observation_request.sub(/^on_/, '')
#           can_add_listener?(event) || can_handle_drag_observation_request?(observation_request) || can_handle_drop_observation_request?(observation_request)
          true # TODO filter by valid listeners only in the future
        end
      end      
      
      def handle_observation_request(keyword, &event_listener)
        return unless observation_request_to_event_mapping.keys.include?(keyword)
        @observation_requests ||= {}
        @observation_requests[keyword] ||= Set.new
        event = nil
        delegate = nil
        [observation_request_to_event_mapping[keyword]].flatten.each do |mapping|
          @observation_requests[keyword] << event_listener
          event = mapping[:event]
          event_handler = mapping[:event_handler]
          potential_event_listener = event_handler&.call(event_listener)
          event_listener = potential_event_listener || event_listener
          delegate = Document.find(listener_path).on(event, &event_listener)
        end
        # TODO update code below for new WidgetProxy API
        EventListenerProxy.new(element_proxy: self, event: event, selector: selector, delegate: delegate)
      end
      
      def add_observer(observer, property_name)
        property_listener_installers = self.class.ancestors.map {|ancestor| widget_property_listener_installers[ancestor]}.compact
        widget_listener_installers = property_listener_installers.map{|installer| installer[property_name.to_s.to_sym]}.compact if !property_listener_installers.empty?
        widget_listener_installers.to_a.each do |widget_listener_installer|
          widget_listener_installer.call(observer)
        end
      end
      
      def set_attribute(attribute_name, *args)
        apply_property_type_converters(attribute_name, args)
        super(attribute_name, *args) # PropertyOwner
      end
      
      def apply_property_type_converters(attribute_name, args)
        if args.count == 1
          value = args.first
          converter = property_type_converters[attribute_name.to_sym]
          args[0] = converter.call(value) if converter
        end
#         if args.count == 1 && args.first.is_a?(ColorProxy)
#           g_color = args.first
#           args[0] = g_color.swt_color
#         end
      end
      
      def property_type_converters
        color_converter = lambda do |value|
          if value.is_a?(Symbol) || value.is_a?(String)
            ColorProxy.new(value)
          else
            value
          end
        end
        @property_type_converters ||= {
          :background => color_converter,
#           :background_image => lambda do |value|
#             if value.is_a?(String)
#               if value.start_with?('uri:classloader')
#                 value = value.sub(/^uri\:classloader\:\//, '')
#                 object = java.lang.Object.new
#                 value = object.java_class.resource_as_stream(value)
#                 value = java.io.BufferedInputStream.new(value)
#               end
#               image_data = ImageData.new(value)
#               on_event_Resize do |resize_event|
#                 new_image_data = image_data.scaledTo(@swt_widget.getSize.x, @swt_widget.getSize.y)
#                 @swt_widget.getBackgroundImage&.dispose
#                 @swt_widget.setBackgroundImage(Image.new(@swt_widget.getDisplay, new_image_data))
#               end
#               Image.new(@swt_widget.getDisplay, image_data)
#             else
#               value
#             end
#           end,
          :foreground => color_converter,
#           :font => lambda do |value|
#             if value.is_a?(Hash)
#               font_properties = value
#               FontProxy.new(self, font_properties).swt_font
#             else
#               value
#             end
#           end,
#           :items => lambda do |value|
#             value.to_java :string
#           end,
          :text => lambda do |value|
#             if swt_widget.is_a?(Browser)
#               value.to_s
#             else
              value.to_s
#             end
          end,
#           :visible => lambda do |value|
#             !!value
#           end,
        }      
      end      
      
      def widget_property_listener_installers
        @swt_widget_property_listener_installers ||= {
#           WidgetProxy => {
#             :focus => lambda do |observer|
#               on_focus_gained { |focus_event|
#                 observer.call(true)
#               }
#               on_focus_lost { |focus_event|
#                 observer.call(false)
#               }
#             end,
#           },
          TextProxy => {
            :text => lambda do |observer|
              on_modify_text { |modify_event|
                observer.call(text)
              }
            end,
#             :caret_position => lambda do |observer|
#               on_event_keydown { |event|
#                 observer.call(getCaretPosition)
#               }
#               on_event_keyup { |event|
#                 observer.call(getCaretPosition)
#               }
#               on_event_mousedown { |event|
#                 observer.call(getCaretPosition)
#               }
#               on_event_mouseup { |event|
#                 observer.call(getCaretPosition)
#               }
#             end,
#             :selection => lambda do |observer|
#               on_event_keydown { |event|
#                 observer.call(getSelection)
#               }
#               on_event_keyup { |event|
#                 observer.call(getSelection)
#               }
#               on_event_mousedown { |event|
#                 observer.call(getSelection)
#               }
#               on_event_mouseup { |event|
#                 observer.call(getSelection)
#               }
#             end,
#             :selection_count => lambda do |observer|
#               on_event_keydown { |event|
#                 observer.call(getSelectionCount)
#               }
#               on_event_keyup { |event|
#                 observer.call(getSelectionCount)
#               }
#               on_event_mousedown { |event|
#                 observer.call(getSelectionCount)
#               }
#               on_event_mouseup { |event|
#                 observer.call(getSelectionCount)
#               }
#             end,
#             :top_index => lambda do |observer|
#               @last_top_index = getTopIndex
#               on_paint_control { |event|
#                 if getTopIndex != @last_top_index
#                   @last_top_index = getTopIndex
#                   observer.call(@last_top_index)
#                 end
#               }
#             end,
          },
#           Java::OrgEclipseSwtCustom::StyledText => {
#             :text => lambda do |observer|
#               on_modify_text { |modify_event|
#                 observer.call(getText)
#               }
#             end,
#           },
#           Button => { #radio?
#             :selection => lambda do |observer|
#               on_widget_selected { |selection_event|
#                 observer.call(getSelection)
#               }
#             end
#           },
#           Java::OrgEclipseSwtWidgets::MenuItem => {
#             :selection => lambda do |observer|
#               on_widget_selected { |selection_event|
#                 observer.call(getSelection)
#               }
#             end
#           },
#           Java::OrgEclipseSwtWidgets::Spinner => {
#             :selection => lambda do |observer|
#               on_widget_selected { |selection_event|
#                 observer.call(getSelection)
#               }
#             end
#           },
        }
      end
      
    end
  end
end

require 'glimmer/swt/browser_proxy'
require 'glimmer/swt/button_proxy'
require 'glimmer/swt/combo_proxy'
require 'glimmer/swt/composite_proxy'
require 'glimmer/swt/label_proxy'
require 'glimmer/swt/list_proxy'
require 'glimmer/swt/tab_folder_proxy'
require 'glimmer/swt/tab_item_proxy'
require 'glimmer/swt/table_column_proxy'
require 'glimmer/swt/table_item_proxy'
require 'glimmer/swt/table_proxy'
require 'glimmer/swt/text_proxy'

require 'glimmer/dsl/opal/widget_expression'
