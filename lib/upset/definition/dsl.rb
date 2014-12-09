# encoding: utf-8

module Upset
  module Definition
    class Dsl
      def initialize(properties)
        @properties = properties
      end

      def valid?
        Schema.new(self.class.property_definitions).validate(@properties).valid?
      end

      private

      def self.property_definitions
        @property_definitions
      end

      def self.required(key, constraint_definition=nil)
        add_property_definition(key, false, constraint_definition)
      end

      def self.optional(key, constraint_definition=nil)
        add_property_definition(key, true, constraint_definition)
      end

      def self.add_property_definition(key, optional, constraint_definition)
        @property_definitions ||= {}
        @property_definitions[key] = ValueProperty.new(create_constraint(constraint_definition), optional)
      end

      def self.create_constraint(constraint_definition)
        if constraint_definition
          constraints = constraint_definition.map do |type, options|
            case type
            when :kind then KindConstraint.new(options)
            when :regexp then RegexpConstraint.new(options)
            when :member then MemberConstraint.new(create_constraint(options))
            when :any then DisjunctiveConstraint.new(*options.map(&method(:create_constraint)))
            when :all then ConjunctiveConstraint.new(*options.map(&method(:create_constraint)))
            end
          end
          ConjunctiveConstraint.new(*constraints)
        else
          ValidConstraint.new
        end
      end
    end
  end
end
