# Copyright (c) 2020-2022 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'opal'

GLIMMER_DSL_OPAL_ROOT = File.expand_path('../..', __FILE__)
GLIMMER_DSL_OPAL_LIB = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib')
 
$LOAD_PATH.unshift(GLIMMER_DSL_OPAL_LIB)

if RUBY_ENGINE == 'opal'
#   GLIMMER_DSL_OPAL_MISSING = File.join(GLIMMER_DSL_OPAL_ROOT, 'lib', 'glimmer-dsl-opal', 'missing')
   
#   $LOAD_PATH.unshift(GLIMMER_DSL_OPAL_MISSING) # missing Ruby classes/methods
  # TODO look into making append_path work (causing some trouble right now)
#   Opal.append_path File.expand_path('../glimmer-dsl-opal/missing', __FILE__)
#   Opal.append_path GLIMMER_DSL_OPAL_MISSING
  module Kernel
    def include_package(package)
      # No Op (just a shim)
    end
    
    def __dir__
      '(dir)'
    end
  end
  
  require 'opal-parser'
  require 'native' # move this to opal-async
  require 'opal-async'
  require 'async/ext'
  require 'to_collection'
  require 'pure-struct'
  require 'os'
  require 'cgi'
  require 'file'
  require 'display'
  require 'glimmer-dsl-opal/vendor/two.min'
  require 'glimmer-dsl-opal/vendor/jquery'
  require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.min'
  require 'glimmer-dsl-opal/vendor/jquery-ui-timepicker/jquery.ui.timepicker'
#   require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.min.css'
#   require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.structure.min.css'
#   require 'glimmer-dsl-opal/vendor/jquery-ui/jquery-ui.theme.min.css'
  require 'opal-jquery'
  require 'opal/jquery/local_storage'
  require 'promise'
 
  require 'facets/hash/symbolize_keys'
  require 'facets/string/underscore'
  require 'glimmer-dsl-opal/ext/class'
  require 'glimmer-dsl-opal/ext/file'
  require 'glimmer'
  require 'glimmer-dsl-opal/ext/exception'
  require 'glimmer-dsl-opal/ext/date'
  require 'glimmer-dsl-opal/ext/glimmer/dsl/engine'
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
  require 'glimmer/config/opal_logger'
  require 'glimmer-dsl-xml'
  require 'glimmer-dsl-css'
  
  Element.alias_native :replace_with, :replaceWith
  Element.alias_native :select
  Element.alias_native :dialog
    
  Glimmer::Config.loop_max_count = 250 # TODO disable
  
  original_logger_level = Glimmer::Config.logger.level
  Glimmer::Config.logger = Glimmer::Config::OpalLogger.new(STDOUT)
  Glimmer::Config.logger.level = original_logger_level
  Glimmer::Config.excluded_keyword_checkers << lambda do |method_symbol, *args|
    method = method_symbol.to_s
    result = false
    result ||= method == '<<'
    result ||= method == 'handle'
  end
else
  require_relative 'glimmer/config'
  require_relative 'glimmer/engine'
end
