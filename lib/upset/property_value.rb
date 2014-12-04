# encoding: utf-8

module Upset
  class PropertyValue
    attr_reader :provider
    def initialize(provider, value)
      @provider = provider
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
