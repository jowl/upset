# encoding: utf-8

module Upset
  module Provision
    class Provider
      def setup
        self
      end

      def [](property)
        if has_key?(property)
          PropertyValue.new(self, @properties[property])
        else
          MissingValue.new(self)
        end
      end

      def keys
        @properties.keys
      end

      def has_key?(property)
        !!@properties && @properties.has_key?(property)
      end

      def self.setup(*args)
        new(*args).setup
      end
    end

    class PropertyValue
      attr_reader :provider, :value
      def initialize(provider, value)
        @provider = provider
        @value = value
      end
    end

    class MissingValue < PropertyValue
      def initialize(provider)
        super(provider, nil)
      end
    end
  end
end

require 'upset/provision/yaml_provider'
