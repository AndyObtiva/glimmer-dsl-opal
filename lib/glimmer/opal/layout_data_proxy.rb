require 'glimmer/opal/property_owner'

module Glimmer
  module Opal
    class LayoutDataProxy
      include PropertyOwner
      attr_reader :parent, :args, :horizontal_alignment, :grab_excess_horizontal_space
    
      def initialize(parent, args)
        @parent = parent
        @args = args
        reapply
      end

      def horizontal_alignment=(horizontal_alignment)
        @horizontal_alignment = horizontal_alignment
        reapply
      end
      
      def grab_excess_horizontal_space=(grab_excess_horizontal_space)
        @grab_excess_horizontal_space = grab_excess_horizontal_space
        reapply
      end

      def reapply
#         @parent.style = <<~CSS
#         CSS
      end
    end
  end
end
