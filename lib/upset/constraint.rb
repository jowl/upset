# encoding: utf-8

module Upset
  module Constraint
    class Result
      attr_reader :reason
      def initialize(satisfied, reason=nil)
        @satisfied = satisfied
        @reason = reason
      end

      def satisfied?
        @satisfied
      end

      def self.satisfied
        new(true)
      end

      def self.unsatisfied(reason)
        new(false, reason)
      end
    end
  end
end

require 'upset/constraint/kind_constraint'
require 'upset/constraint/valid_constraint'
