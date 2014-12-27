# encoding: utf-8

module Upset
  module Transformation
    class IntegerParser
      def call(value)
        Integer(value)
      end
    end

    class FloatParser
      def call(value)
        Float(value)
      end
    end

    class BooleanParser
      def call(value)
        case value
        when true, TRUE_LOWER, TRUE_UPPER then true
        when false, FALSE_LOWER, FALSE_UPPER then false
        else
          raise ArgumentError, 'not able to parse %s as a boolean' % value
        end
      end

      private

      TRUE_LOWER = 'true'.freeze
      TRUE_UPPER = 'TRUE'.freeze
      FALSE_LOWER = 'false'.freeze
      FALSE_UPPER = 'FALSE'.freeze
    end
  end
end
