# encoding: utf-8

module Upset
  module Definition
    class EvaluatedConstraint
      attr_reader :reason
      def initialize(satisfied, reason)
        @satisfied = satisfied
        @reason = reason
      end

      def evaluate(_)
        raise AlreadyEvaluatedError, 'Constraint has already been evaluated'
      end

      def satisfied?
        !!@satisfied
      end
    end

    class Constraint
      def evaluate(_)
        unsatisfied('Cannot satisfy constraint without a relation')
      end

      protected

      def satisfied
        SATISFIED_CONSTRAINT
      end

      def unsatisfied(reason)
        EvaluatedConstraint.new(false, reason)
      end

      private

      SATISFIED_CONSTRAINT = EvaluatedConstraint.new(true, nil)
    end

    AlreadyEvaluatedError = Class.new(UpsetError)
  end
end

require 'upset/definition/constraints/conjunctive_constraint'
require 'upset/definition/constraints/connective_constraint'
require 'upset/definition/constraints/disjunctive_constraint'
require 'upset/definition/constraints/kind_constraint'
require 'upset/definition/constraints/member_constraint'
require 'upset/definition/constraints/regexp_constraint'
require 'upset/definition/constraints/valid_constraint'
