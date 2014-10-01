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
      @configuration = deep_freeze(@providers.reduce(@default_provider) { |config, provider| deep_merge(config, provider) })
      @previous_providers = @providers.dup
    end

    def deep_merge(hsh, other_hash)
      hsh.merge(other_hash) do |key, oldval, newval|
        if oldval.is_a?(Hash) && newval.is_a?(Hash)
          deep_merge(oldval, newval)
        else
          newval
        end
      end
    end

    def deep_freeze(object)
      object.each(&method(:deep_freeze)) if object.is_a?(Enumerable)
      object.freeze
    end
  end
end
