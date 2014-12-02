# encoding: utf-8

require 'yaml'

module Upset
  module Provision
    class YamlProvider < Provider
      def initialize(path)
        @path = path
      end

      def setup
        @properties = YAML.load_file(@path)
        self
      end
    end
  end
end
