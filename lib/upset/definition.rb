# encoding: utf-8

require 'upset/property_definition'

module Upset
  class Definition
    def initialize(property_definitions)
      @property_definitions = property_definitions
    end

    def validate(configuration)
      @property_definitions.each do |property, definition|
        if configuration.has_property?(property)
          constraint = definition.constraint(configuration[property])
          raise InvalidPropertyError, constraint.reason unless constraint.satisfied?
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
