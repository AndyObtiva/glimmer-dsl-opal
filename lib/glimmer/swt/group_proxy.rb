require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    # Adapter for org.eclipse.swt.widgets.Group
    #
    # Follows Adapter Pattern
    class GroupProxy < CompositeProxy
      attr_reader :text
      
      def text=(value)
        @text = value
        dom_element.find('legend').html(@text) if @text
      end
      
      def element
        'fieldset'
      end
      
      def dom
        @dom ||= html {
          fieldset(id: id, class: name) {
            legend {@text} if @text
          }
        }.to_s
      end
    end
  end
end
