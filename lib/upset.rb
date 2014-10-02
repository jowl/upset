# encoding: utf-8

module Upset
  UpsetError = Class.new(StandardError)
end

require 'upset/configuration'
require 'upset/constraint'
require 'upset/definition'
require 'upset/provider'
