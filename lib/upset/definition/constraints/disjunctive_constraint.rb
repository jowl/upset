# encoding: utf-8

require 'upset/definition/constraints/connective_constraint'

module Upset
  module Definition
    class DisjunctiveConstraint < ConnectiveConstraint
      def satisfied_by?(satisfied_constraints, _)
        !satisfied_constraints.empty?
      end
    end
  end
end
