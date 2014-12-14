# encoding: utf-8

require 'upset/definition/constraints/kind_constraint'

module Upset
  module Definition
    class RangeConstraint < KindConstraint
      def initialize(lower, upper)
        @lower = lower
        @upper = upper
        super(Comparable)
      end

      def evaluate(value)
        if (kind_constraint = super(value)).satisfied?
          if satisfies_lower?(value) && satisfies_upper?(value)
            satisfied
          elsif @lower.nil?
            unsatisfied 'Expected %s to be less than %s' % [value, @upper]
          elsif @upper.nil?
            unsatisfied 'Expected %s to be greater than %s' % [value, @lower]
          else
            unsatisfied 'Expected %s to be between %s and %s' % [value, @lower, @upper]
          end
        else
          kind_constraint
        end
      end

      private

      def satisfies_upper?(value)
        @upper.nil? || value <= @upper
      end

      def satisfies_lower?(value)
        @lower.nil? || value >= @lower
      end
    end
  end
end
