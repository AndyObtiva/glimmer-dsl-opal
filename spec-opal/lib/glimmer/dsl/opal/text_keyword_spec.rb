require 'spec_helper'

module GlimmerSpec
  RSpec.describe 'text keyword' do
    include Glimmer
    
    let(:title) {'Hello, World!'}
        
    it 'renders text widget' do
      Document.ready? do
        @target = shell {
          @text = text {
            text title
          }
        }
        @target.open
        
        expect(@text).to be_a(Glimmer::SWT::TextProxy)
         
        text_element = Document.find('body > div#shell-1.shell > input[type=text]#text-1.text').first
        expect(text_element).to be_a(Element)
        expect(text_element.value).to eq(title)
      end
    end    
  end
end
