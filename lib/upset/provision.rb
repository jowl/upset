# encoding: utf-8

module Upset
  module Provision
    class Provider
      def [](property)
        if has_key?(property)
          PropertyValue.new(self, @properties[property])
        end
      end

      def keys
        @properties ? @properties.keys : []
      end

      def has_key?(property)
        !!@properties && @properties.has_key?(property)
      end
    end

    class PropertyValue
      attr_reader :provider, :value
      def initialize(provider, value)
        @provider = provider
        @value = value
      end
    end
  end
end

require 'upset/provision/yaml_provider'
