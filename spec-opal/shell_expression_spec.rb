require 'spec_helper'

require 'glimmer-dsl-opal'
# require_relative '../lib/glimmer-dsl-opal'

module GlimmerSpec
  describe 'Glimmer::DSL::Opal::ShellExpression' do
    include Glimmer
    
    it 'sets window title' do
      @target = shell {
        text 'Hello, World!'
      }
    end
  end
end
