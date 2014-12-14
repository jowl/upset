# encoding: utf-8

require 'upset/definition/constraints/kind_constraint'

module Upset
  module Definition
    class FileConstraint < KindConstraint
      def initialize
        super(String)
      end

      private

      def kind_safe_evaluate(value)
        if File.exists?(value)
          satisfied
        else
          unsatisfied('%s does not exist' % value)
        end
      end
    end
  end
end
