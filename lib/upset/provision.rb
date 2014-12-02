# encoding: utf-8

module Upset
  module Provision
    class Provider
      def setup
        self
      end

      def [](property)
        @properties[property]
      end

      def keys
        @properties.keys
      end

      def has_key?(property)
        @properties.has_key?(property)
      end

      def self.setup(*args)
        new(*args).setup
      end
    end
  end
end

require 'upset/provision/yaml_provider'
