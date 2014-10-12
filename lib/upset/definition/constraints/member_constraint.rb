# encoding: utf-8

module Upset
  module Definition
    class MemberConstraint < Constraint
      def initialize(member_constraint)
        @member_constraint = member_constraint
      end

      def evaluate(value)
        if value.is_a?(Enumerable)
          evaluated_constraints = value.map do |member|
            @member_constraint.evaluate(member)
          end
          unsatisfied_constraints = evaluated_constraints.reject(&:satisfied?)
          if unsatisfied_constraints.empty?
            satisfied
          else
            unsatisfied(unsatisfied_constraints.map(&:reason).join(COMMA))
          end
        else
          unsatisfied('Expected Enumerable, got %s' % [value.class.name])
        end
      end

      private

      COMMA = ', '.freeze
    end
  end
end
