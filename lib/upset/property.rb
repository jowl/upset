# encoding: utf-8

module Upset
  class Property
    attr_reader :provider, :key, :value
    def initialize(provider, key, value)
      @provider = provider
      @key = key
      @value = value
    end
  end
end
