require 'spec_helper'
require 'glimmer-dsl-opal'
 
module GlimmerSpec
  RSpec.describe 'Glimmer::DSL::Opal::ShellExpression' do
    include Glimmer
     
    it 'sets window title' do
      @target = shell {
        text 'Hello, World!'
        label {
          text 'Hello, World!'
        }
      }
      @target.open
      expect(1 + 1).to eq(2)
    end
  end
end
