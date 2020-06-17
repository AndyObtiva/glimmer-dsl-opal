require 'opal'
require 'opal-parser'
require 'glimmer'

GLIMMER_DSL_OPAL_ROOT = File.expand_path('../..', __FILE__)
GLIMMER_DSL_OPAL_LIB = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib')

$LOAD_PATH.unshift(GLIMMER_DSL_OPAL_LIB)

require 'glimmer/dsl/opal/dsl' 
