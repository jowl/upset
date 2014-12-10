# encoding: utf-8

require 'upset/definition/dsl/constraints'

module Upset
  module Definition
    module Dsl
      class SchemaContext
        include Constraints

        attr_reader :property_definitions
        def initialize(&schema_definition)
          @property_definitions = {}
          instance_exec(&schema_definition) if schema_definition
        end

        def required_property(key, constraint=nil, &block)
          @property_definitions[key] = property_definition(false, constraint, block, key)
        end

        def optional_property(key, constraint=nil, &block)
          @property_definitions[key] = property_definition(true, constraint, block, key)
        end

        def default(constraint=nil, &block)
          @property_definitions.default = property_definition(true, constraint, block)
        end

        def build
          Schema.new(@property_definitions)
        end

        private

        def initialize_dup(other)
          super
          @property_definitions = other.property_definitions.dup
        end

        def property_definition(optional, constraint, schema_definition, key=nil)
          if schema_definition && constraint
            key = key ? "Property #{key.inspect}" : 'Default property'
            raise SchemaError, "#{key} has both constraint and schema"
          elsif schema_definition
            schema = SchemaContext.new(&schema_definition).build
            SchemaProperty.new(schema, optional)
          else
            constraint ||= ValidConstraint.new
            ValueProperty.new(constraint, optional)
          end
        end
      end

      SchemaError = Class.new(UpsetError)
    end
  end
end
