# encoding: utf-8

module Upset
  class Definition
    class RegexpConstraint < EvaluableConstraint
      def initialize(pattern)
        @pattern = pattern
      end

      def evaluate(value)
        if value.is_a?(String) && @pattern =~ value
          satisfied
        else
          unsatisfied('Expected %s to match %s' % [value.inspect, @pattern.inspect])
        end
      end
    end
  end
end
