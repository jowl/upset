# encoding: utf-8

module Upset
  class Definition
    class ValidConstraint < EvaluableConstraint
      def evaluate(_)
        satisfied
      end
    end
  end
end
