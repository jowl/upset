# encoding: utf-8

module Upset
  module Definition
    class Definition
      def validate(_)
        raise 'must be implemented in subclass'
      end

      protected

      def valid
        ValidationResult.new(true, nil)
      end

      def invalid(reason)
        ValidationResult.new(false, reason)
      end
    end

    class ValidationResult
      attr_reader :reason
      def initialize(valid, reason)
        @valid = valid
        @reason = Array(reason)
      end

      def valid?
        !!@valid
      end

      def self.join(results)
        invalid_results = results.reject(&:valid?)
        if invalid_results.empty?
          new(true, nil)
        else
          new(false, invalid_results.map(&:reason))
        end
      end
    end
  end
end

require 'upset/definition/property_definition'
require 'upset/definition/schema'
require 'upset/definition/constraint'
require 'upset/definition/dsl'
