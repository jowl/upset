module SpecConstraints
  class InvalidConstraint < Upset::Definition::EvaluableConstraint
    def evaluate(_)
      unsatisfied('This will always be unsatisfied')
    end
  end
end
