# encoding: utf-8

module Upset
  module Definition
    class ValueDefinition < PropertyDefinition
      def initialize(constraint, optional)
        @constraint = constraint
        super(optional)
      end

      def validate(value)
        evaluated_constraint = @constraint.evaluate(value)
        if evaluated_constraint.satisfied?
          valid
        else
          invalid(evaluated_constraint.reason)
        end
      end
    end
  end
end
