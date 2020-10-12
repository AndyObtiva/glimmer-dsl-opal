require 'opal'

if RUBY_PLATFORM == 'opal'
  GLIMMER_DSL_OPAL_ROOT = File.expand_path('../..', __FILE__)
  GLIMMER_DSL_OPAL_LIB = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib')
  GLIMMER_DSL_OPAL_MISSING = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib', 'glimmer-dsl-opal', 'missing')
   
  $LOAD_PATH.unshift(GLIMMER_DSL_OPAL_LIB)
  $LOAD_PATH.unshift(GLIMMER_DSL_OPAL_MISSING) # missing Ruby classes/methods
  
  require 'native' # move this to opal-async
  require 'opal-async'
  require 'async/ext'
  require 'glimmer-dsl-opal/vendor/jquery'
  require 'opal-jquery'
  require 'glimmer'
  require 'facets/hash/symbolize_keys'  
  require 'glimmer-dsl-opal/ext/exception'

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
  end
  
end
