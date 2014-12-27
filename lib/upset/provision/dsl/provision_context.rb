# encoding: utf-8

require 'upset/provision/dsl/providers'

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

        def add_provider(provider)
          @providers.unshift(provider)
        end

        def initialize_dup(other)
          super
          @providers = other.build
        end
      end
    end
  end
end
