# encoding: utf-8

module Upset
  module Definition
    AlreadyEvaluatedError = Class.new(UpsetError)

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
  end
end
