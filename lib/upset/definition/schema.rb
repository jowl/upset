# encoding: utf-8

module Upset
  module Definition
    class Schema < Definition
      def initialize(property_definitions)
        @property_definitions = property_definitions
      end

      def validate(configuration)
        invalid_results = validate_properties(configuration).reject(&:valid?)
        if invalid_results.empty?
          valid
        else
          invalid('Invalid configuration', *invalid_results)
        end
      end

      private

      def validate_properties(configuration)
        (@property_definitions.keys | configuration.keys).map do |property|
          if configuration.has_key?(property)
            if (definition = @property_definitions[property])
              if (validation_result = definition.validate(configuration[property])).valid?
                valid
              else
                invalid("Invalid property #{property.inspect}", validation_result)
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
      end
    end
  end
end
