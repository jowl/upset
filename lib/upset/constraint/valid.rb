# encoding: utf-8

module Upset
  class Constraint
    class Valid < self
      def initialize
        @satisfied = true
      end
    end
  end
end
