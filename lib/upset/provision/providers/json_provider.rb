# encoding: utf-8

require 'json'

module Upset
  module Provision
    class JsonProvider < Provider
      def initialize(path)
        @path = path
      end

      def setup
        File.open(@path) { |file| self.properties = JSON.load(file) }
        self
      end
    end
  end
end
