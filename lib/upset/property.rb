# encoding: utf-8

module Upset
  class Property
    attr_reader :provider, :key
    def initialize(provider, key, value)
      @provider = provider
      @key = key
      @value = deep_freeze(value)
    end

    def value
      deep_freeze(@value)
    end

    private

    def deep_freeze(object)
      object.each(&method(:deep_freeze)) if object.is_a?(Enumerable)
      object.freeze
    end
  end
end
