# encoding: utf-8

module Upset
  module Constraint
    class Valid
      include ConstraintFactory

      def evaluate(_)
        satisfied
      end
    end
  end
end
