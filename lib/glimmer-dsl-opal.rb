require 'opal'
require 'opal-async'
require 'browser'
require 'browser/effects'
require 'delegate'
require 'glimmer'

GLIMMER_DSL_OPAL_ROOT = File.expand_path('../..', __FILE__)
GLIMMER_DSL_OPAL_LIB = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib')

$LOAD_PATH.unshift(GLIMMER_DSL_OPAL_LIB)

require 'glimmer/dsl/opal/dsl'
require 'glimmer/data_binding/ext/observable_model'
