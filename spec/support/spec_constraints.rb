# encoding: utf-8

module SpecConstraints
  class InvalidConstraint < Upset::Definition::Constraint
    def evaluate(_)
      unsatisfied('This will always be unsatisfied')
    end
  end
end
