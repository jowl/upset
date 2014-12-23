# encoding: utf-8

require 'upset/definition/dsl/constraints'

module Upset
  module Definition
    module Dsl
      class SchemaContext
        include Constraints

        attr_reader :property_contexts
        def initialize(&schema_definition)
          @property_contexts = {}
          instance_exec(&schema_definition) if schema_definition
        end

        def required(key, &block)
          @property_contexts[key] = PropertyContext.new(false, block)
        end

        def optional(key, &block)
          @property_contexts[key] = PropertyContext.new(true, block)
        end

        def residual(&block)
          @property_contexts.default = PropertyContext.new(true, block)
        end

        def build
          property_definitions = Hash[@property_contexts.map { |key, property_context| [key, property_context.build] }]
          if @property_contexts.default
            property_definitions.default = @property_contexts.default.build
          end
          Schema.new(property_definitions)
        end

        private

        def initialize_dup(other)
          super
          @property_contexts = other.property_contexts.dup
        end

        class PropertyContext
          def initialize(optional, schema_definition)
            @optional = optional
            @schema_definition = schema_definition
          end

          def is(constraint)
            @constraint = constraint
          end
          alias :are :is

          def build
            if @schema_definition
              schema = SchemaContext.new(&@schema_definition).build
              SchemaProperty.new(schema, @optional)
            else
              ValueProperty.new(@constraint || ValidConstraint.new, @optional)
            end
          end
        end
      end
    end
  end
end
