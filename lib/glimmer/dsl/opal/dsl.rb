require 'opal'
require 'browser'

require 'glimmer/dsl/engine'
# Dir[File.expand_path('../*_expression.rb', __FILE__)].each {|f| require f}
require 'glimmer/dsl/opal/shell_expression'
require 'glimmer/dsl/opal/label_expression'
require 'glimmer/dsl/opal/property_expression'
require 'glimmer/dsl/opal/combo_expression'
require 'glimmer/dsl/opal/composite_expression'
require 'glimmer/dsl/opal/button_expression'
require 'glimmer/dsl/opal/bind_expression'
# require 'glimmer/dsl/opal/data_binding_expression'
require 'glimmer/dsl/opal/combo_selection_data_binding_expression'
require 'glimmer/dsl/opal/widget_listener_expression'

module Glimmer
  module DSL
    module Opal
      Engine.add_dynamic_expressions(
       Opal,
       %w[
         widget_listener
         combo_selection_data_binding
         property
       ]
      )
    end
  end
end
