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
      Document.ready? do
        Glimmer::SWT::WidgetProxy.reset_max_id_numbers!
        @target.dispose if @target && @target.respond_to?(:dispose)
      end
    end
     
    it 'renders empty shell with title and CSS shell-style div' do
      Document.ready? do
        @target = shell {
          text title
        }
        @target.open
        
        expect(@target).to be_a(Glimmer::SWT::ShellProxy)
  
        expect(Document.title).to eq(title)
        expect(Document.find('body > div#shell-1.shell').first).to be_a(Element)
        expect(Document.find('body > div#shell-1.shell > style.shell-style').first.html).to eq(@target.style_dom_css)
      end
    end
    
    # TODO add test for minimum_size
    it 'renders shell with label content' do
      Document.ready? do
        @target = shell {
          @label = label {
            text title
          }
        }
        @target.open
        
        expect(@label).to be_a(Glimmer::SWT::LabelProxy)

        label_element = Document.find('body > div#shell-1.shell > label#label-1.label').first
        expect(label_element).to be_a(Element)
        expect(label_element.html).to eq(title)
      end
    end
    
    it 'renders shell with composite containing combo (read only)' do
      Document.ready? do
        @target = shell {
          @composite = composite {
            @combo = combo(:read_only) {
            }
          }
        }
        @target.open
        
        expect(@composite).to be_a(Glimmer::SWT::CompositeProxy)
        expect(@combo).to be_a(Glimmer::SWT::ComboProxy)
        
        composite_element = Document.find('body > div#shell-1.shell > div#composite-1.composite').first
        expect(composite_element).to be_a(Element)
        combo_element = Document.find('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo').first
        expect(combo_element).to be_a(Element)
      end
    end
    
    xit 'renders shell with composite containing data-bound combo (read only)' do
      person = Person.new
      @target = shell {
        composite {
          combo(:read_only) {
            selection bind(person, :country)
          }
        }
      }
       
      Document.ready? do
        raise 'hell'
        composite_element = Document.find('body > div#shell-1.shell > div#composite-1.composite').first
        expect(composite_element).to be_a(Browser::DOM::Element)
         
        combo_element = Document.find('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo').first
        expect(combo_element).to be_a(Browser::DOM::Element::Select)
        expect(combo_element.value).to eq('Canada')
         
        combo_option_element1 = Document.find('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(1)').first
        expect(combo_option_element1).to be_a(Browser::DOM::Element)
        expect(combo_option_element1.inner_html).to eq('')
         
        combo_option_element2 = Document.find('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(2)').first
        expect(combo_option_element2).to be_a(Browser::DOM::Element)
        expect(combo_option_element2.inner_html).to eq('Canada')
         
        combo_option_element3 = Document.find('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(3)').first
        expect(combo_option_element3).to be_a(Browser::DOM::Element)
        expect(combo_option_element3.inner_html).to eq('US')
         
        combo_option_element4 = Document.find('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo > option:nth-child(4)').first
        expect(combo_option_element4).to be_a(Browser::DOM::Element)
        expect(combo_option_element4.inner_html).to eq('Mexico')      
         
        combo_element.value = 'US'
         
        expect(person.country).to eq('US')
 
        person.country = 'Mexico'
         
        expect(combo_element.value).to eq('Mexico')
      end      
    end
     
    xit 'renders shell with composite containing listener-bound button' do
      person = Person.new
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
       
      Document.ready? do
        combo_element = Document.find('body > div#shell-1.shell > div#composite-1.composite > select#combo-1.combo').first
        person.country = 'Mexico'
         
        expect(combo_element.value).to eq('Mexico')
 
      end      
    end
  end
end
