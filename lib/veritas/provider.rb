# encoding: utf-8

module Veritas
  class Provider < Hash
    def reload
      self
    end
  end
end

require 'veritas/provider/simple'
