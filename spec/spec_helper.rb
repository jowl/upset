# encoding: utf-8

$: << File.expand_path('../../lib', __FILE__)

require 'simplecov'

SimpleCov.start do
  add_group 'Source', 'lib'
  add_group 'Unit tests', 'spec/upset'
end

require 'upset'
