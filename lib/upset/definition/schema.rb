# encoding: utf-8

module Upset
  module Definition
    class Schema < Definition
      def initialize(property_definitions)
        @property_definitions = property_definitions
      end

      def validate(configuration)
        validation_results = (@property_definitions.keys | configuration.keys).map do |property|
          if configuration.has_key?(property)
            if (definition = @property_definitions[property])
              if (validation_result = definition.validate(configuration[property])).valid?
                valid
              else
                invalid_property(property, validation_result)
              end
            else
              invalid("Undefined property #{property.inspect}")
            end
          elsif @property_definitions[property].optional?
            valid
          else
            invalid("Missing #{property.inspect}")
          end
        end
        ValidationResult.join(validation_results)
      end

      private

      def invalid_property(property, validation_result)
        invalid(["Invalid property #{property.inspect}", validation_result.reason])
      end
    end
  end
end
