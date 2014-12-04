# encoding: utf-8

module Upset
  module Provision
    class Provider
      def initialize(properties)
        @properties = properties
      end

      def [](property)
        if has_key?(property)
          PropertyValue.new(self, get(property))
        end
      end

      def keys
        properties.keys
      end

      def has_key?(property)
        !!properties && properties.has_key?(property)
      end

      protected

      attr_accessor :properties

      def get(property)
        properties[property]
      end
    end
  end
end

require 'upset/provision/yaml_provider'
