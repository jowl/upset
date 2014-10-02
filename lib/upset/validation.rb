# encoding: utf-8

module Upset
  module Validation
    class Result
      attr_reader :reason
      def initialize(valid, reason=nil)
        @valid = valid
        @reason = reason
      end

      def valid?
        @valid
      end

      def self.valid
        new(true)
      end

      def self.invalid(reason)
        new(false, reason)
      end
    end
  end
end

require 'upset/validation/kind_validator'
