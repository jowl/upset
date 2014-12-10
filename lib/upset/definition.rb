# encoding: utf-8

module Upset
  module Definition
    class Definition
      def validate(_)
        raise 'must be implemented in subclass'
      end

      protected

      def valid
        ValidationResult.new(nil)
      end

      def invalid(reason)
        ValidationResult.new(reason)
      end
    end

    class ValidationResult
      attr_reader :reason
      def initialize(reason)
        @reason = Array(reason)
      end

      def valid?
        @reason.empty?
      end

      def self.join(results)
        invalid_results = results.reject(&:valid?)
        if invalid_results.empty?
          new(nil)
        else
          new(invalid_results.map(&:reason))
        end
      end
    end
  end
end

require 'upset/definition/property_definition'
require 'upset/definition/schema'
require 'upset/definition/constraint'
require 'upset/definition/dsl'
