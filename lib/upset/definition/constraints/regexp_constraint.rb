# encoding: utf-8

require 'upset/definition/constraints/kind_constraint'

module Upset
  module Definition
    class RegexpConstraint < KindConstraint
      def initialize(pattern)
        @pattern = pattern
        super(String)
      end

      private

      def kind_safe_evaluate(value)
        if @pattern =~ value
          satisfied
        else
          unsatisfied('Expected %s to match %s' % [value.inspect, @pattern.inspect])
        end
      end
    end
  end
end
