require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class RadioProxy < WidgetProxy
      attr_reader :selection, :text
      
      def text=(value)
        @text = value
        dom_element.val(@text)
        label_dom_element.html(@text)
      end

      def selection=(value)
        @selection = value
        dom_element.prop('checked', @selection)
      end
      
      def element
        'input'
      end

      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'change'
          }, 
        }
      end
      
      def label_id
        "#{id}-label"
      end
      
      def label_class
        "#{name}-label"
      end
      
      def label_dom_element
        Element.find("##{label_id}")
      end
      
      def dom
        radio_text = @text
        radio_id = id
        radio_style = css
        radio_class = name
        radio_selection = @selection
        options = {type: 'radio', id: radio_id, name: parent.id, style: radio_style, class: radio_class, value: radio_text, style: 'min-width: 27px;'}
        options[checked: 'checked'] if radio_selection        
        @dom ||= html {
          span {
            input(options) {
            }
            label(id: label_id, class: label_class, for: radio_id) {
              radio_text
            }
          }
        }.to_s
      end
    end
  end
end
