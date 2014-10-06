# encoding: utf-8

module Upset
  module Provision
    class Provider < Hash
      def reload
        self
      end
    end
  end
end

require 'upset/provision/simple_provider'
