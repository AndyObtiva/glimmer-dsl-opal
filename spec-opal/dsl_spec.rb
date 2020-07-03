require 'spec_helper'
require 'glimmer-dsl-opal'
#TODO adjust implementation of shell to leave `div class="rspec-report"` untouched
   
module GlimmerSpec
  RSpec.describe 'Glimmer::DSL::Opal::ShellExpression' do
    include Glimmer
    
    let(:title) {'Hello, World!'}
    
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
    
    after do
      Glimmer::SWT::WidgetProxy.reset_max_id_numbers!
      @target.dispose if @target.respond_to?(:dispose)
    end
     
    it 'renders empty shell with title and CSS shell-style div' do
      @target = shell {
        text title
      }
      @target.open

      expect($document.css('body > div#shell-1.shell').first).to be_a(Browser::DOM::Element)
      expect($document.css('body > div#shell-1.shell > div.shell-style').first.inner_html).to eq(@target.head_style_css)
      expect($document.title).to eq(title)
    end
    
    it 'renders shell with label content' do
      @target = shell {
        label {
          text title
        }
      }
      @target.open

      label_element = $document.css('body > div#shell-1.shell > label#label-1.label').first
      expect(label_element).to be_a(Browser::DOM::Element)
      expect(label_element.inner_html).to eq(title)
    end
    
    it 'renders shell with composite containing combo (read only)' do
      @target = shell {
        composite {
          combo(:read_only) {
          }
        }
      }
      
      composite_element = $document.css('body > div#shell-1.shell > div#composite-1.composite').first
      expect(composite_element).to be_a(Browser::DOM::Element)
      combo_element = $document.css('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo').first
      expect(combo_element).to be_a(Browser::DOM::Element::Select)
    end
    
    it 'renders shell with composite containing data-bound combo (read only)' do
      person = Person.new
      @target = shell {
        composite {
          combo(:read_only) {
            selection bind(person, :country)
          }
        }
      }
      
      composite_element = $document.css('body > div#shell-1.shell > div#composite-1.composite').first
      expect(composite_element).to be_a(Browser::DOM::Element)
      
      combo_element = $document.css('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo').first
      expect(combo_element).to be_a(Browser::DOM::Element::Select)
      
      combo_option_element1 = $document.css('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(1)').first
      expect(combo_option_element1).to be_a(Browser::DOM::Element)
      expect(combo_option_element1.inner_html).to eq('')
      
      combo_option_element2 = $document.css('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(2)').first
      expect(combo_option_element2).to be_a(Browser::DOM::Element)
      expect(combo_option_element2.inner_html).to eq('Canada')
      
      combo_option_element3 = $document.css('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(3)').first
      expect(combo_option_element3).to be_a(Browser::DOM::Element)
      expect(combo_option_element3.inner_html).to eq('US')
      
      combo_option_element4 = $document.css('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(4)').first
      expect(combo_option_element4).to be_a(Browser::DOM::Element)
      expect(combo_option_element4.inner_html).to eq('Mexico')
    end
  end
end
