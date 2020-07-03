require 'spec_helper'
require 'glimmer-dsl-opal'
#TODO adjust implementation of shell to leave `div class="rspec-report"` untouched
   
module GlimmerSpec
  RSpec.describe 'Glimmer::DSL::Opal::ShellExpression' do
    include Glimmer
    
    let(:title) {'Hello, World!'}
    
    after do
      Glimmer::SWT::WidgetProxy.reset_max_id_numbers
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
  end
end
