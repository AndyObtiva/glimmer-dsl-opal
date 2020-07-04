require 'spec_helper'

module GlimmerSpec
  RSpec.describe 'button keyword' do
    include Glimmer
    
    before :all do
      class Person
        attr_accessor :country, :country_options
        
        def initialize
          self.country_options=["", "Canada", "US", "Mexico"]
          self.country = "Canada"
        end
      
        def reset_country
          self.country = "Canada"
        end
      end    
    end
    
    after :all do
      GlimmerSpec.send(:remove_const, :Person) if GlimmerSpec.const_defined?(:Person)
    end
    
    it 'renders shell with composite containing listener-bound button' do
      person = Person.new
      Document.ready? do
        @target = shell {
          composite {
            button {
              text "Reset"
              on_widget_selected do
                person.reset_country
              end
            }
          }
        }
         
        button_element = Document.find('body > div#shell-1.shell > div#composite-1.composite > button#button-1.button').first
        expect(button_element).to be_a(Element)
        
        person.country = 'Mexico'
        button_element.trigger(:click)
        
        expect(person.country).to eq('Canada')
      end      
    end
  end
end
