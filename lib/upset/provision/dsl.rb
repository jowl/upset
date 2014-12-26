# encoding: utf-8

require 'upset/provision/dsl/provision_context'

module Upset
  module Provision
    module Dsl
      def create
        providers = provision_context.build
        new(providers.shift).tap do |configuration|
          configuration.providers = providers
        end
      end

      def provision(*args, &block)
        provision_context.instance_exec(*args, &block)
        self
      end

      def provision_context
        @provision_context ||= begin
          if superclass.respond_to?(:provision_context)
            superclass.provision_context.dup
          else
            ProvisionContext.new
          end
        end
      end
    end
  end
end
