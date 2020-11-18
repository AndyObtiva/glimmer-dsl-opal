require 'glimmer/swt/widget_proxy'
# require 'glimmer/swt/image_proxy'

module Glimmer
  module SWT
    class LabelProxy < WidgetProxy
      attr_reader :text, :background_image, :image, :alignment
      
      def initialize(parent, args, block)
        super(parent, args, block)
        self.alignment = [:left, :center, :right].detect {|align| args.detect { |arg| SWTProxy[align] == arg } }
      end

      def text=(value)
        @text = value
        dom_element.html(value)
      end
      
      def background_image=(*image_options)
        # TODO consider if there is a difference between background_image and image in label and to have one reuse the other
        # TODO finish implementation
#         @background_image = Glimmer::SWT::ImageProxy.create(*image_options)
#         dom_element.css('background-image', @background_image.image_data.dom_element.src)
      end
      
      def image=(*image_options)
        # TODO finish implementation
#         @image = Glimmer::SWT::ImageProxy.create(*image_options)
#         dom_element.css('background-image', @image.image_data.dom_element.src)
      end
      
      def element
        'label'
      end

      def alignment=(value)
        # TODO consider storing swt value in the future instead
        @alignment = value
        dom_element.css('text-align', @alignment.to_s)
      end
      
      def dom
        label_text = @text
        label_id = id
        label_class = name
        @dom ||= html {
          label(id: label_id, class: label_class) {
            label_text
          }
        }.to_s
      end
    end
  end
end
