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
          return @schema unless block_given?
          @schema = SchemaContext.new(&block).build
          self
        end
      end
    end
  end
end
