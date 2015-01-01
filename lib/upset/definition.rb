# encoding: utf-8

module Upset
  module Definition
    class Definition
      def validate(_)
        raise 'must be implemented in subclass'
      end

      protected

      def valid
        ValidationResult.new(nil, [])
      end

      def invalid(message, *causes)
        ValidationResult.new(message, causes)
      end
    end

    class ValidationResult
      attr_reader :message, :causes
      def initialize(message, causes=[])
        @message = message
        @causes = causes
      end

      def valid?
        @message.nil?
      end

      def trace(indent=0)
        @causes.flat_map do |validation_result|
          [
            TWO_SPACES * indent + validation_result.message,
            *validation_result.trace(indent + 1)
          ]
        end
      end

      private

      TWO_SPACES = '  '.freeze
    end
  end
end

require 'upset/definition/property_definition'
require 'upset/definition/schema'
require 'upset/definition/constraint'
require 'upset/definition/dsl'
