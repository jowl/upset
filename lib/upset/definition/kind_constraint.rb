# encoding: utf-8

module Upset
  module Definition
    class KindConstraint < EvaluableConstraint
      def initialize(kind)
        @kind = kind
      end

      def evaluate(value)
        if value.kind_of?(@kind)
          satisfied
        else
          unsatisfied('Expected %s, got %s' % [@kind.name, value.class.name])
        end
      end
    end
  end
end
