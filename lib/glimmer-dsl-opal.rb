$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

if RUBY_ENGINE == 'opal'
  require 'glimmer'
  
  require 'glimmer/dsl/opal/dsl' 
end
