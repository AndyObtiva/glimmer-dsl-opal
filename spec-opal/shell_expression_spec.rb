require 'spec_helper'
require 'glimmer-dsl-opal'
#TODO adjust implementation of shell to leave `div class="rspec-report"` untouched
   
module GlimmerSpec
  RSpec.describe 'Glimmer::DSL::Opal::ShellExpression' do
    include Glimmer
    
    let(:window_title) {'Hello, World!'}
    
    after do
      @target.dispose if @target.respond_to?(:dispose)
    end
     
    it 'renders empty shell with title' do
      @target = shell {
        text window_title
        label {
          text 'hello there'
        }
      }
      @target.open

      expect($document.css('body > div#shell-1.shell').first).to be_a(Browser::DOM::Element)
      expect($document.css('body > div#shell-1.shell > div.shell-style').first.inner_html).to eq(@target.head_style_css)
      expect($document.title).to eq(window_title)
    end
  end
end
