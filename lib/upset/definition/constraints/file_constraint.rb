# encoding: utf-8

require 'upset/definition/constraints/kind_constraint'

module Upset
  module Definition
    class FileConstraint < KindConstraint
      def initialize
        super(String)
      end

      def evaluate(value)
        if (kind_constraint = super(value)).satisfied?
          if File.exists?(value)
            satisfied
          else
            unsatisfied('%s does not exist' % value)
          end
        else
          kind_constraint
        end
      end
    end
  end
end
