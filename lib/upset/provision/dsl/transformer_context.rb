# encoding: utf-8

require 'upset/provision/dsl/transformations'

module Upset
  module Provision
    module Dsl
      class TransformerContext
        include Transformations

        def initialize(provider, &block)
          @provider = provider
          @transformations = {}
          instance_exec(&block) if block_given?
        end

        def all
          @provider.keys
        end

        def build
          Transformation::Transformer.new(@provider, @transformations)
        end

        private

        def add_transformation(transformation, keys)
          keys.flatten.each { |key| @transformations[key] = transformation }
        end
      end
    end
  end
end
