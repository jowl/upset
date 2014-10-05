# encoding: utf-8

module Upset
  module Constraint
    class Evaluated
      attr_reader :reason
      def initialize(satisfied, reason)
        @satisfied = satisfied
        @reason = reason
      end

      def satisfied?
        !!@satisfied
      end
    end
  end

  module ConstraintFactory
    def satisfied
      SATISFIED_CONSTRAINT
    end

    def unsatisfied(reason)
      Constraint::Evaluated.new(false, reason)
    end

    private

    SATISFIED_CONSTRAINT = Constraint::Evaluated.new(true, nil)
  end
end

require 'upset/constraint/kind'
require 'upset/constraint/regexp'
require 'upset/constraint/valid'
