# encoding: utf-8

require 'upset/definition/dsl/constraints'

module Upset
  module Definition
    module Dsl
      class SchemaContext
        include Constraints

        def initialize(&block)
          @property_contexts = {}
          instance_exec(&block)
        end

        def required_property(key, &block)
          add_property_context(key, false, &block)
        end

        def optional_property(key, &block)
          add_property_context(key, true, &block)
        end

        def build
          Schema.new(property_definitions)
        end

        private

        def add_property_context(key, optional, &block)
          if block_given?
            @property_contexts[key] = SchemaPropertyContext.new(optional, &block)
          else
            @property_contexts[key] = ValuePropertyContext.new(optional)
          end
        end

        def property_definitions
          @property_contexts.each_with_object({}) { |(k, ctx), h| h[k] = ctx.build }
        end

        class SchemaPropertyContext
          def initialize(optional, &block)
            @optional = optional
            @schema = SchemaContext.new(&block).build
          end

          def build
            SchemaProperty.new(@schema, @optional)
          end
        end

        class ValuePropertyContext
          def initialize(optional)
            @optional = optional
            @constraint = ValidConstraint.new
          end

          def is(constraint)
            @constraint = constraint
          end
          alias :are :is

          def build
            ValueProperty.new(@constraint, @optional)
          end
        end
      end
    end
  end
end
