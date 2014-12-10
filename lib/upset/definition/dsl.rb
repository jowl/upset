# encoding: utf-8

require 'upset/definition/dsl/schema_context'

module Upset
  module Definition
    module Dsl
      def self.included(mod)
        mod.extend(SchemaDsl)
      end

      def validate(configuration=self)
        self.class.schema.validate(configuration)
      end

      module SchemaDsl
        def schema(&block)
          return schema_context.build unless block_given?
          schema_context.instance_exec(&block)
          self
        end

        def schema_context
          @schema_context ||= begin
            if superclass.respond_to?(:schema_context)
              superclass.schema_context
            else
              SchemaContext.new
            end
          end
        end
      end
    end
  end
end
