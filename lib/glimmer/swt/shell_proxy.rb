require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/layout_proxy'
require 'glimmer/swt/display_proxy'
require 'glimmer/swt/point'

module Glimmer
  module SWT
    class ShellProxy < CompositeProxy
      STYLE = <<~CSS
        html {
          width: 100%;
          height: 100%;
        }
        body {
          width: 100%;
          height: 100%;
          margin: 0;
        }
        .shell {
          height: 100%;
          margin: 0;
        }
        .shell iframe {
          width: 100%;
          height: 100%;
        }
      CSS
    
      # TODO consider renaming to ShellProxy to match SWT API
      attr_reader :minimum_size
      attr_accessor :menu_bar # TODO implement menu bar rendering
    
      WIDTH_MIN = 130
      HEIGHT_MIN = 0
      
      def initialize(args)
        @args = args
        @children = []
#         Document.ready? do end # TODO consider embedding this jQuery call in so outside consumers don't have to use it
        Document.find('body').empty unless ENV['RUBY_ENV'] == 'test'
        render
        @layout = FillLayoutProxy.new(self, [])
        @layout.margin_width = 0
        @layout.margin_height = 0
        self.minimum_size = Point.new(WIDTH_MIN, HEIGHT_MIN)
        DisplayProxy.instance.shells << self
      end
      
      def element
        'div'
      end
      
      def parent_path
        'body'
      end

      def text
        $document.title
      end

      def text=(value)
        Document.title = value
      end
      
      def minimum_size=(width_or_minimum_size, height = nil)
        @minimum_size = height.nil? ? width_or_minimum_size : Point.new(width_or_minimum_size, height)
        return if @minimum_size.nil?
        dom_element.css('min-width', "#{@minimum_size.x}px")
        dom_element.css('min-height', "#{@minimum_size.y}px")
      end
      
      def style_dom_css
        <<~CSS
          .hide {
            display: none !important;
          }
          .selected {
            background: rgb(80, 116, 211);
            color: white;
          }
        CSS
      end
            
      def dom
        i = 0
        body_id = id
        body_class = ([name] + css_classes.to_a).join(' ')
        @dom ||= html {
          div(id: body_id, class: body_class) {
            # TODO consider supporting the idea of dynamic CSS building on close of shell that adds only as much CSS as needed for widgets that were mentioned
            style(class: 'common-style') {
              style_dom_css
            }
            [LayoutProxy, WidgetProxy].map(&:descendants).reduce(:+).each do |style_class|
              if style_class.constants.include?('STYLE')
                style(class: "#{style_class.name.split(':').last.underscore.gsub('_', '-').sub(/-proxy$/, '')}-style") {
                  style_class::STYLE
                }
              end
            end
            ''
          }
        }.to_s
      end
      
      def open
        # TODO consider the idea of delaying rendering till the open method
        # TODO make it start as hidden and show shell upon open
        Glimmer::SWT::DisplayProxy.instance.shells << self
      end
    end
  end
end
