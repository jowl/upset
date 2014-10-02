# encoding: utf-8

module Upset
  class Provider < Hash
    def reload
      self
    end
  end
end

require 'upset/provider/simple'
