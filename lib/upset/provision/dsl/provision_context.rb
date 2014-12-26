# encoding: utf-8

require 'upset/provision/dsl/providers'

module Upset
  module Provision
    module Dsl
      class ProvisionContext
        include Providers

        attr_reader :providers
        def initialize
          @providers = []
        end

        alias :build :providers

        private

        def add_provider(provider)
          @providers.unshift(provider)
        end

        def initialize_dup(other)
          super
          @providers.concat(other.providers)
        end
      end
    end
  end
end
