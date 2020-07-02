require 'glimmer/swt/widget_proxy'
require 'glimmer/opal/document_proxy'

module Glimmer
  module SWT
    class ShellProxy < WidgetProxy
      def initialize(*args)
        document_proxy = ::Glimmer::Opal::DocumentProxy.new(args)
        __setobj__(document_proxy)
      end
    end
  end
end
