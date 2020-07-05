require 'opal'
if RUBY_PLATFORM == 'opal'
  require 'opal-async'
  require 'jquery' # included in glimmer-dsl-opal
  require 'opal-jquery'
  require 'glimmer'
   
  GLIMMER_DSL_OPAL_ROOT = File.expand_path('../..', __FILE__)
  GLIMMER_DSL_OPAL_LIB = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib')
   
  $LOAD_PATH.unshift(GLIMMER_DSL_OPAL_LIB)
   
  require 'glimmer/dsl/opal/dsl'
  require 'glimmer/data_binding/ext/observable_model'
   
  require 'glimmer-dsl-xml'
  Element.alias_native :replace_with, :replaceWith
end
