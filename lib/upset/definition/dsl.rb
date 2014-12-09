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
          return @schema_context.build unless block_given?
          @schema_context ||= SchemaContext.new
          @schema_context.instance_exec(&block)
          self
        end
      end
    end
  end
end
