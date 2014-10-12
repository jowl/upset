# encoding: utf-8

module Upset
  module Definition
    class ConnectiveConstraint < Constraint
      def initialize(*constraints)
        @constraints = constraints
      end

      def evaluate(value)
        evaluated_constraints = @constraints.map do |constraint|
          constraint.evaluate(value)
        end
        satisfied_constraints, unsatisfied_constraints = evaluated_constraints.partition(&:satisfied?)
        if satisfied_by?(satisfied_constraints, unsatisfied_constraints)
          satisfied
        else
          unsatisfied(unsatisfied_constraints.map(&:reason).join(COMMA))
        end
      end

      protected

      def satisfied_by?(satisfied_constraints, unsatisfied_constraints)
        raise '#satisfied_by? must be overridden in subclass'
      end

      private

      COMMA = ', '.freeze
    end
  end
end
