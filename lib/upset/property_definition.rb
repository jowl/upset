# encoding: utf-8

module Upset
  class PropertyDefinition
    def initialize(constraint, required)
      @constraint = constraint
      @required = required
    end

    def optional?
      !@required
    end

    def constraint(value)
      @constraint.evaluate(value)
    end
  end
end
