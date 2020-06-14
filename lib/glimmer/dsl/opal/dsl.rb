require 'opal'
require 'browser'

require 'glimmer/dsl/engine'
# Dir[File.expand_path('../*_expression.rb', __FILE__)].each {|f| require f}
require 'glimmer/dsl/opal/shell_expression'
require 'glimmer/dsl/opal/label_expression'
require 'glimmer/dsl/opal/property_expression'

module Glimmer
  module DSL
    module Opal
      Engine.add_dynamic_expressions(
       Opal,
       %w[
         property
       ]
      )
    end
  end
end
