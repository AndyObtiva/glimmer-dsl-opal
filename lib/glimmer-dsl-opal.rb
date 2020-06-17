# if RUBY_ENGINE == 'opal' # or test if env is test
  $LOAD_PATH.unshift(File.expand_path('..', __FILE__))
  
  require 'opal'
  require 'opal-parser'
  require 'glimmer'
  
  require 'glimmer/dsl/opal/dsl' 
# end
