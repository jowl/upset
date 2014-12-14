# encoding: utf-8

module Upset
  module Definition
    class KindConstraint < Constraint
      def initialize(kind)
        @kind = kind
      end

      def evaluate(value)
        if value.kind_of?(@kind)
          kind_safe_evaluate(value)
        else
          unsatisfied('Expected %s, got %s' % [@kind.name, value.class.name])
        end
      end

      protected

      def kind_safe_evaluate(_)
        satisfied
      end
    end
  end
end
