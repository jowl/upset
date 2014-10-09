# encoding: utf-8

require 'upset/definition/evaluated_constraint'

module Upset
  module Definition
    class EvaluableConstraint
      protected

      def satisfied
        SATISFIED_CONSTRAINT
      end

      def unsatisfied(reason)
        EvaluatedConstraint.new(false, reason)
      end

      private

      SATISFIED_CONSTRAINT = EvaluatedConstraint.new(true, nil)
    end
  end
end
