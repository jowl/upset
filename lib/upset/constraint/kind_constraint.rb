# encoding: utf-8

module Upset
  module Constraint
    class KindConstraint
      def initialize(kind)
        @kind = kind
      end

      def evaluate(value)
        if value.kind_of?(@kind)
          Result.satisfied
        else
          Result.unsatisfied('Expected %s, got %s' % [@kind.name, value.class.name])
        end
      end
    end
  end
end
