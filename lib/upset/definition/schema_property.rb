# encoding: utf-8

module Upset
  module Definition
    class SchemaProperty < PropertyDefinition
      def initialize(schema, optional)
        @schema = schema
        super(optional)
      end

      def validate(configuration)
        @schema.validate(configuration)
      end
    end
  end
end