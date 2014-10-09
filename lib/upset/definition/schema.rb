# encoding: utf-8

module Upset
  module Definition
    class Schema < Definition
      def initialize(property_definitions)
        @property_definitions = property_definitions
      end

      def validate(configuration)
        validation_results = []
        @property_definitions.each do |property, definition|
          if configuration.has_property?(property)
            validation_result = definition.validate(configuration[property])
            unless validation_result.valid?
              validation_results << invalid('Invalid property %s: %s' % [property.inspect, validation_result.reason])
            end
          else
            validation_results << invalid("Missing #{property.inspect}") unless definition.optional?
          end
        end
        if !(unknown = configuration.properties - @property_definitions.keys).empty?
          validation_results << invalid('Unknown property(s): %s' % unknown.map(&:inspect).join(', '))
        end
        ValidationResult.join(validation_results)
      end
    end
  end
end
