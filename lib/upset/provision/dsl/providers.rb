# encoding: utf-8

module Upset
  module Provision
    module Dsl
      module Providers
        def properties(properties, &block)
          add_provider(Provider.new(properties), &block)
        end

        def json(path, &block)
          add_provider(JsonProvider.new(path).setup, &block)
        end

        def yaml(path, &block)
          add_provider(YamlProvider.new(path).setup, &block)
        end
      end
    end
  end
end
