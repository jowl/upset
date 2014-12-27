# encoding: utf-8

require 'upset/property'

module Upset
  module Provision
    class Provider
      def initialize(properties)
        @properties = properties
      end

      def [](key)
        if has_key?(key)
          Property.new(self, key, get(key))
        end
      end

      def keys
        properties.keys
      end

      def has_key?(key)
        !!properties && properties.has_key?(key)
      end

      protected

      attr_accessor :properties

      def get(key)
        properties[key]
      end
    end
  end
end

require 'upset/provision/dsl'
require 'upset/provision/providers/yaml_provider'
