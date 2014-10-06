# encoding: utf-8

require 'upset/definition/connective_constraint'

module Upset
  class Definition
    class ConjunctiveConstraint < ConnectiveConstraint
      private
      def satisfied_by?(_, unsatisfied_constraints)
        unsatisfied_constraints.empty?
      end
    end
  end
end
