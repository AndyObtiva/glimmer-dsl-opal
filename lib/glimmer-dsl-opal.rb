require 'opal'
if RUBY_PLATFORM == 'opal'
  require 'opal-async'
  require 'jquery' # included in glimmer-dsl-opal
  require 'opal-jquery'
  require 'glimmer'

  puts 'logging delay by 10 seconds'
  logger = Glimmer::Config.logger
  original_add_method = logger.class.instance_method(:add)
  logger.define_singleton_method("__original_add", original_add_method)
  logger.singleton_class.send(:define_method, :add) do |*args|
    Async::Timeout.new 10000 do
      __original_add(*args)
    end
  end  
   
  GLIMMER_DSL_OPAL_ROOT = File.expand_path('../..', __FILE__)
  GLIMMER_DSL_OPAL_LIB = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib')
   
  $LOAD_PATH.unshift(GLIMMER_DSL_OPAL_LIB)
   
  require 'glimmer/dsl/opal/dsl'
  require 'glimmer/data_binding/ext/observable_model'
   
  require 'glimmer-dsl-xml'
  Element.alias_native :replace_with, :replaceWith
end
