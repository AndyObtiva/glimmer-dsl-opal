require 'glimmer/swt/property_owner'

module Glimmer
  module Opal
    class ElementProxy
      include Glimmer
      include Glimmer::SWT::PropertyOwner
      attr_reader :parent, :args, :css_classes, :css, :children, :enabled
      
      class << self
        def next_id_number_for(name)
          @max_id_numbers[name] = max_id_number_for(name) + 1
        end
        
        def max_id_number_for(name)
          @max_id_numbers[name] = max_id_numbers[name] || 0
        end
        
        def max_id_numbers
          @max_id_numbers ||= reset_max_id_numbers
        end
        
        def reset_max_id_numbers
          @max_id_numbers = {}
        end
      end
      
      def initialize(parent, args)
        @parent = parent
        @args = args
        @children = Set.new
        @css_classes = Set.new
        @css = ''
        @enabled = true
        @parent.add_child(self)
      end
      
      def dispose
        dom.remove
      end

      def add_child(child)
#         return if @children.include?(child) # TODO consider adding an option to enable this if needed to prevent dom repetition        
        @children << child
        dom << child.dom
      end
      
      def enabled=(value)
        @enabled = value
        redraw
      end

      def redraw
        if @dom
          old_dom = @dom
          @dom = nil
          old_dom.replace dom
        else
          dom
        end
        @children.each do |child|          
          child.redraw
        end
      end
      
      # Subclasses must override with their own mappings
      def observation_request_to_event_mapping
        {}
      end
      
      def name
        self.class.name.split('::').last.underscore.sub(/_proxy$/, '')
      end
      
      def id
        @id ||= "#{name}-#{ElementProxy.next_id_number_for(name)}"
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
        @css_classes << css_class
        redraw
      end
      
      def add_css_classes(css_classes)
        @css_classes += css_classes
        redraw
      end
      
      def remove_css_class(css_class)
        @css_classes.delete(css_class)
        redraw
      end
      
      def remove_css_classes(css_classes)
        @css_classes -= css_classes
        redraw
      end
      
      def clear_css_classes(css_class)
        @css_classes.clear
        redraw
      end
      
      def css=(css)
        @css = css
        redraw
      end
      
      def has_style?(symbol)
        @args.include?(symbol) # not a very solid implementation. Bring SWT constants eventually
      end
      
      def handle_observation_request(keyword, &event_listener)
        return unless observation_request_to_event_mapping.keys.include?(keyword)
        event = nil
        delegate = nil
        [observation_request_to_event_mapping[keyword]].flatten.each do |mapping|
          event = mapping[:event]
          event_handler = mapping[:event_handler]
          potential_event_listener = event_handler&.call(event_listener)
          event_listener = event_handler&.call(event_listener) || event_listener
          delegate = $document.on(event, selector, &event_listener)
        end
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
        super(attribute_name, *args)
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
        @property_type_converters ||= {
#           :background => color_converter,
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
#           :foreground => color_converter,
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
#           ElementProxy => {
#             :focus => lambda do |observer|
#               on_focus_gained { |focus_event|
#                 observer.call(true)
#               }
#               on_focus_lost { |focus_event|
#                 observer.call(false)
#               }
#             end,
#           },
          InputProxy => {
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
#           InputProxy => {
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
