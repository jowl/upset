# encoding: utf-8

module Upset
  class Constraint
    class Kind < self
      def initialize(kind)
        @kind = kind
      end

      def evaluate(value)
        @satisfied = value.kind_of?(@kind)
        unless @satisfied
          @reason ='Expected %s, got %s' % [@kind.name, value.class.name]
        end
        self
      end
    end
  end
end
