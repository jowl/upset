# encoding: utf-8

module Upset
  module Definition
    class EvaluatedConstraint
      attr_reader :reason
      def initialize(reason)
        @reason = reason
      end

      def evaluate(_)
        raise AlreadyEvaluatedError, 'Constraint has already been evaluated'
      end

      def satisfied?
        @reason.nil?
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
        EvaluatedConstraint.new(reason)
      end

      private

      SATISFIED_CONSTRAINT = EvaluatedConstraint.new(nil)
    end

    AlreadyEvaluatedError = Class.new(UpsetError)
  end
end

require 'upset/definition/constraints/conjunctive_constraint'
require 'upset/definition/constraints/connective_constraint'
require 'upset/definition/constraints/disjunctive_constraint'
require 'upset/definition/constraints/file_constraint'
require 'upset/definition/constraints/kind_constraint'
require 'upset/definition/constraints/member_constraint'
require 'upset/definition/constraints/range_constraint'
require 'upset/definition/constraints/regexp_constraint'
require 'upset/definition/constraints/valid_constraint'
