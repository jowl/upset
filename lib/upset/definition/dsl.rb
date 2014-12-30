# encoding: utf-8

require 'upset/definition/dsl/schema_context'

module Upset
  module Definition
    module Dsl
      def self.included(mod)
        mod.extend(ClassMethods)
      end

      def validate(configuration=self)
        self.class.schema.validate(configuration)
      end

      def validate!(configuration=self)
        unless (validation_result = validate(configuration)).valid?
          raise ValidationError
        end
        true
      end

      module ClassMethods
        def schema
          schema_context.build
        end

        def definition(&block)
          schema_context.instance_exec(&block)
          self
        end

        def schema_context
          @schema_context ||= begin
            if superclass.respond_to?(:schema_context)
              superclass.schema_context.dup
            else
              SchemaContext.new
            end
          end
        end
      end
    end

    ValidationError = Class.new(UpsetError)
  end
end
