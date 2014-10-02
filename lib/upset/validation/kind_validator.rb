# encoding: utf-8

module Upset
  module Validation
    class KindValidator
      def initialize(kind)
        @kind = kind
      end

      def validate(value)
        if value.kind_of?(@kind)
          Result.valid
        else
          Result.invalid('Expected %s, got %s' % [@kind.name, value.class.name])
        end
      end
    end
  end
end
