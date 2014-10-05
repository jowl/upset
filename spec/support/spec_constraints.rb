module SpecConstraints
  class Invalid
    include Upset::ConstraintFactory

    def evaluate(_)
      unsatisfied('This will always be unsatisfied')
    end
  end
end
