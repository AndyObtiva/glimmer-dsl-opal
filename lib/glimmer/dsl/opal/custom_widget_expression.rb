# Copyright (c) 2020 Andy Maleh
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

require 'glimmer'
require 'glimmer/dsl/expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/ui/custom_widget'
require 'glimmer/ui/custom_shell'

module Glimmer
  module DSL
    module Opal
      class CustomWidgetExpression < Expression
        # TODO Make custom widgets automatically generate static expressions
        include ParentExpression
        include TopLevelExpression

        def can_interpret?(parent, keyword, *args, &block)
          !!UI::CustomWidget.for(keyword)
        end
  
        def interpret(parent, keyword, *args, &block)
          options = args.last.is_a?(Hash) ? args.pop : {}
          UI::CustomWidget.for(keyword).new(parent, *args, options, &block)
        end
  
        def add_content(parent, &block)
          # TODO consider avoiding source_location
          if block.source_location == parent.content&.__getobj__.source_location
            parent.content.call(parent) unless parent.content.called?
          else
            super
          end
        end
      end
    end
  end
end