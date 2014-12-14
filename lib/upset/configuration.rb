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
      first_provider { |provider| provider[key] }
    end

    def has_property?(key)
      first_provider { |provider| provider.has_key?(key) }
    end
    alias :has_key? :has_property?

    def properties
      @providers.reduce(@default_provider.keys) { |properties, provider| properties | provider.keys }
    end
    alias :keys :properties

    private

    def first_provider(&block)
      block.call(@providers.reverse_each.find(&block) || @default_provider)
    end
  end
end
