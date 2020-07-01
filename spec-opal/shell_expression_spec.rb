require 'spec_helper'
require 'glimmer-dsl-opal'
#TODO adjust implementation of shell to leave `div class="rspec-report"` untouched
   
module GlimmerSpec
  RSpec.describe 'Glimmer::DSL::Opal::ShellExpression' do
    include Glimmer
    
    after do
      @target.dispose if @target.respond_to?(:dispose)
    end
     
    it 'sets window title' do
      @target = shell {
        text 'Hello, World!'
        label {
          text 'Hello, World!'
        }
      }
      @target.open
      expect($document.css('div#document-1').first).to be_a(Browser::DOM::Element)
      expect($document.css('label#label-1').first).to be_a(Browser::DOM::Element)
    end
  end
end
