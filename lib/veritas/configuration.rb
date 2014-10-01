# encoding: utf-8

module Veritas
  class Configuration
    attr_accessor :providers
    def initialize(default_provider)
      @default_provider = default_provider
      @providers = []
    end

    def [](property)
      merge_providers if dirty?
      @configuration[property]
    end

    def reload
      @default_provider.reload
      @providers.each(&:reload)
      self
    end

    private

    def dirty?
      @providers != @previous_providers
    end

    def merge_providers
      @configuration = deep_freeze(@providers.reduce(@default_provider) { |config, provider| config.merge(provider) })
      @previous_providers = @providers.dup
    end

    def deep_freeze(object)
      object.each(&method(:deep_freeze)) if object.is_a?(Enumerable)
      object.freeze
    end
  end
end
