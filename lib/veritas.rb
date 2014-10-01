# encoding: utf-8

module Veritas
  VeritasError = Class.new(StandardError)
end

require 'veritas/configuration'
require 'veritas/definition'
require 'veritas/provider'
