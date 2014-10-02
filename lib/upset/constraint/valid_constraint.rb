# encoding: utf-8

module Upset
  module Constraint
    class ValidConstraint
      def evaluate(_)
        Result.satisfied
      end
    end
  end
end
