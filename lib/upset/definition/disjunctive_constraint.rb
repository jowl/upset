# encoding: utf-8

require 'upset/definition/connective_constraint'

module Upset
  class Definition
    class DisjunctiveConstraint < ConnectiveConstraint
      def satisfied_by?(satisfied_constraints, _)
        !satisfied_constraints.empty?
      end
    end
  end
end
