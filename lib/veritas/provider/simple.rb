# encoding: utf-8

module Veritas
  class Provider
    class Simple < self
      def initialize(properties)
        replace(properties)
      end
    end
  end
end
