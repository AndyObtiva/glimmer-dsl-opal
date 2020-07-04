require 'spec_helper'

module GlimmerSpec
  RSpec.describe 'shell keyword' do
    include Glimmer
    
    let(:title) {'Hello, World!'}
    
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
  end
end
