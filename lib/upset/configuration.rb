# encoding: utf-8

module Upset
  class Configuration
    attr_accessor :providers
    def initialize(default_provider)
      @default_provider = default_provider
      @providers = []
    end

    def [](key)
      (property = property(key)) && property.value
    end

    def fetch(key, *default, &block)
      if has_property?(key)
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
      @providers.reverse_each do |provider|
        if (property = provider[key])
          return property
        end
      end
      @default_provider[key]
    end

    def has_property?(key)
      @providers.reverse_each do |provider|
        return true if provider.has_key?(key)
      end
      @default_provider.has_key?(key)
    end
    alias :has_key? :has_property?

    def properties
      @providers.reduce(@default_provider.keys) { |properties, provider| properties | provider.keys }
    end
    alias :keys :properties
  end
end
