# encoding: utf-8

module Upset
  module Definition
    class ValidConstraint < Constraint
      def evaluate(_)
        satisfied
      end
    end
  end
end
