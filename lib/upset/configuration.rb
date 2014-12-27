# encoding: utf-8

module Upset
  class Configuration
    attr_accessor :providers
    def initialize(providers=nil)
      @providers = Array(providers)
    end

    def [](key)
      (property = property(key)) && property.value
    end

    def fetch(key, *default, &block)
      if (argument_count = 1 + default.size) > 2
        raise ArgumentError, 'wrong number of arguments (%d for 1..2)' % argument_count
      elsif has_property?(key)
        self[key]
      elsif block_given?
        block.call
      elsif !default.empty?
        default.first
      else
        raise KeyError, 'key not found: %s' % key.inspect
      end
    end

    def property(key)
      @providers.reduce(nil) do |property, provider|
        break property if property
        provider[key]
      end
    end

    def has_property?(key)
      @providers.any? { |provider| provider.has_key?(key) }
    end
    alias :has_key? :has_property?

    def properties
      @providers.reduce([]) { |properties, provider| properties | provider.keys }
    end
    alias :keys :properties
  end
end
