# encoding: utf-8

module Upset
  class Constraint
    attr_reader :reason
    def satisfied?
      !!@satisfied
    end

    def evaluate(_)
      self
    end
  end
end

require 'upset/constraint/kind'
require 'upset/constraint/valid'
