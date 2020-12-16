require 'glimmer/swt/property_owner'

module Glimmer
  module SWT
    class LayoutProxy
      include Glimmer::SWT::PropertyOwner
      
      class << self
        def inherited(klass)
          descendants << klass
        end
        
        def descendants
          @descendants ||= []
        end
        
        # Factory Method that translates a Glimmer DSL keyword into a WidgetProxy object
        def for(keyword, parent, args)
          the_layout_class = layout_class(keyword) || Glimmer::SWT::GridLayoutProxy
          the_layout_class.new(parent, args)
        end
        
        def layout_class(keyword)
          class_name_alternative = keyword.camelcase(:upper)
          class_name_main = "#{class_name_alternative}Proxy"
          a_layout_class = Glimmer::SWT.const_get(class_name_main.to_sym) rescue Glimmer::SWT.const_get(class_name_alternative.to_sym)
          a_layout_class if a_layout_class.ancestors.include?(Glimmer::SWT::LayoutProxy)
        rescue => e
          Glimmer::Config.logger.debug "Layout #{keyword} was not found!"
          nil
        end
        
        def layout_exists?(keyword)
          !!layout_class(keyword)
        end
      end
      
      attr_reader :parent, :args
        
      def initialize(parent, args)
        @parent = parent
        @parent = parent.body_root if @parent.is_a?(Glimmer::UI::CustomWidget)
        @parent.css_classes.each do |css_class|
          @parent.remove_css_class(css_class) if css_class.include?('layout')
        end
        @args = args
        @parent.add_css_class(css_class)
        @parent.layout = self
        self.margin_width = 15 if respond_to?(:margin_width=)
        self.margin_height = 15 if respond_to?(:margin_height=)
      end

      def css_class
        self.class.name.split('::').last.underscore.sub(/_proxy$/, '').gsub('_', '-')
      end
      
      def reapply
        # subclasses can override this
      end
      
      # Decorates widget dom. Subclasses may override. Returns widget dom by default.
      def dom(widget_dom)
        widget_dom
      end
    end
  end
end

require 'glimmer/swt/grid_layout_proxy'
require 'glimmer/swt/fill_layout_proxy'
require 'glimmer/swt/row_layout_proxy'
