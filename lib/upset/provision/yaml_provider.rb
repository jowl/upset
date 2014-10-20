# encoding: utf-8

require 'yaml'

module Upset
  module Provision
    class YamlProvider < Provider
      def initialize(path)
        @path = path
      end

      def reload
        replace(YAML.load_file(@path))
      end
    end
  end
end
