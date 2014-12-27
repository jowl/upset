# encoding: utf-8

require 'upset/provision/dsl/providers'
require 'upset/provision/dsl/transformations'

module Upset
  module Provision
    module Dsl
      class ProvisionContext
        include Providers

        def initialize
          @providers = []
        end

        def build
          @providers.dup
        end

        private

        def add_provider(provider, &block)
          if block_given?
            transformer = TransformerContext.new(provider, &block).build
            @providers.unshift(transformer)
          else
            @providers.unshift(provider)
          end
        end

        def initialize_dup(other)
          super
          @providers = other.build
        end

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
            Upset::Transformation::Transformer.new(@provider, @transformations)
          end

          private

          def add_transformation(transformation, keys)
            keys.flatten.each { |key| @transformations[key] = transformation }
          end
        end
      end
    end
  end
end
