# encoding: utf-8

module Upset
  module Provision
    class SimpleProvider < Provider
      def initialize(properties)
        replace(properties)
      end
    end
  end
end
