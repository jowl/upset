# encoding: utf-8

module Upset
  module Provision
    class Provider < Hash
      def initialize
      end

      def reload
        self
      end

      def self.setup(*args)
        new(*args).reload
      end
    end
  end
end

require 'upset/provision/simple_provider'
require 'upset/provision/yaml_provider'
