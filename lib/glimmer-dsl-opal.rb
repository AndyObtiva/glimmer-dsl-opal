$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'glimmer'

require 'glimmer/dsl/opal/dsl' if RUBY_ENGINE == 'opal'
