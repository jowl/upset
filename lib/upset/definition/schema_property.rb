# encoding: utf-8

module Upset
  module Definition
    class SchemaProperty < PropertyDefinition
      def initialize(schema, optional)
        @schema = schema
        super(optional)
      end

      def validate(configuration)
        if configuration.is_a?(Configuration) || configuration.is_a?(Hash)
          @schema.validate(configuration)
        else
          invalid 'Expected Configuration or Hash, got %s' % configuration.class
        end
      end
    end
  end
end
