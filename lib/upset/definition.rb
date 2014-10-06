# encoding: utf-8

require 'upset/property_definition'
require 'upset/definition/evaluable_constraint'
require 'upset/definition/conjunctive_constraint'
require 'upset/definition/disjunctive_constraint'
require 'upset/definition/kind_constraint'
require 'upset/definition/member_constraint'
require 'upset/definition/regexp_constraint'
require 'upset/definition/valid_constraint'

module Upset
  class Definition
    def initialize(property_definitions)
      @property_definitions = property_definitions
    end

    def validate(configuration)
      @property_definitions.each do |property, definition|
        if configuration.has_property?(property)
          constraint = definition.constraint(configuration[property])
          unless constraint.satisfied?
          raise InvalidPropertyError, 'Invalid property %s: %s' % [property.inspect, constraint.reason]
          end
        else
          raise MissingPropertyError, "Missing #{property.inspect}" unless definition.optional?
        end
      end
      if !(unknown = configuration.properties - @property_definitions.keys).empty?
        raise UnknownPropertyError.new('Unknown property(s): %s' % unknown.map(&:inspect).join(', '))
      end
      true
    end

    def describe
    end
  end

  ValidationError = Class.new(UpsetError)
  MissingPropertyError = Class.new(ValidationError)
  InvalidPropertyError = Class.new(ValidationError)
  UnknownPropertyError = Class.new(ValidationError)
end
