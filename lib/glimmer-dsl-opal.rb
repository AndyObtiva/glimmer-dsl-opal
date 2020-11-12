require 'opal'

GLIMMER_DSL_OPAL_ROOT = File.expand_path('../..', __FILE__)
GLIMMER_DSL_OPAL_LIB = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib')
 
$LOAD_PATH.unshift(GLIMMER_DSL_OPAL_LIB)

if RUBY_PLATFORM == 'opal'
#   GLIMMER_DSL_OPAL_MISSING = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib', 'glimmer-dsl-opal', 'missing')
   
#   $LOAD_PATH.unshift(GLIMMER_DSL_OPAL_MISSING) # missing Ruby classes/methods
  # TODO look into making append_path work (causing some trouble right now)
#   Opal.append_path pd File.expand_path('../glimmer-dsl-opal/missing', __FILE__)
#   Opal.append_path GLIMMER_DSL_OPAL_MISSING
  
  require 'opal-parser'
  require 'native' # move this to opal-async
  require 'opal-async'
  require 'async/ext'
  require 'glimmer-dsl-opal/vendor/jquery'
  require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.min'
  require 'glimmer-dsl-opal/vendor/jquery-ui-timepicker/jquery.ui.timepicker'
#   require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.min.css'
#   require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.structure.min.css'
#   require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.theme.min.css'
  require 'opal-jquery'
  require 'glimmer'
  require 'facets/hash/symbolize_keys'
  require 'glimmer-dsl-opal/ext/exception'
  require 'glimmer-dsl-opal/ext/date'
  require 'uri'

  # Spiking async logging
#   logger = Glimmer::Config.logger
#   original_add_method = logger.class.instance_method(:add)
#   logger.define_singleton_method("__original_add", original_add_method)
#   logger.singleton_class.send(:define_method, :add) do |*args|
#     Async::Timeout.new 10000 do
#       __original_add(*args)
#     end
#   end
      
  require 'glimmer/dsl/opal/dsl'
  require 'glimmer/data_binding/ext/observable_model'
   
  require 'glimmer-dsl-xml'
  require 'glimmer-dsl-css'
  Element.alias_native :replace_with, :replaceWith
  
#   Glimmer::Config.loop_max_count = 20
  
  Glimmer::Config.excluded_keyword_checkers << lambda do |method_symbol, *args|
    method = method_symbol.to_s
    result = false
    result ||= method == '<<'
    result ||= method == 'handle'
  end
else
  require "glimmer/engine"
end
