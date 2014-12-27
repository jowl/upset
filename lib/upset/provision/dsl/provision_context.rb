# encoding: utf-8

require 'upset/provision/dsl/providers'
require 'upset/provision/dsl/transformer_context'

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
            @providers << transformer
          else
            @providers << provider
          end
        end

        def initialize_dup(other)
          super
          @providers = other.build
        end
      end
    end
  end
end
