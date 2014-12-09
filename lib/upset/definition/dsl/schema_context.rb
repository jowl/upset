# encoding: utf-8

require 'upset/definition/dsl/constraints'

module Upset
  module Definition
    module Dsl
      class SchemaContext
        include Constraints

        def initialize(&block)
          @property_definitions = {}
          instance_exec(&block)
        end

        def required_property(key, constraint=nil, &block)
          add_property_definition(key, false, constraint, block)
        end

        def optional_property(key, constraint=nil, &block)
          add_property_definition(key, true, constraint, block)
        end

        def build
          Schema.new(@property_definitions)
        end

        private

        def add_property_definition(key, optional, constraint, schema_definition)
          if schema_definition && constraint
            raise SchemaError, "Property #{key.inspect} has both constraint and schema"
          elsif schema_definition
            schema = SchemaContext.new(&schema_definition).build
            @property_definitions[key] = SchemaProperty.new(schema, optional)
          else
            constraint ||= ValidConstraint.new
            @property_definitions[key] = ValueProperty.new(constraint, optional)
          end
        end
      end

      SchemaError = Class.new(UpsetError)
    end
  end
end
