# encoding: utf-8

module Upset
  module Definition
    class PropertyDefinition < Definition
      def initialize(optional)
        @optional = optional
      end

      def optional?
        !!@optional
      end
    end
  end
end

require 'upset/definition/schema_definition'
require 'upset/definition/value_definition'
