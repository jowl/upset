# encoding: utf-8

module Upset
  module Provision
    module Dsl
      module Providers
        def properties(properties)
          add_provider Provider.new(properties)
        end

        def yaml(path)
          add_provider YamlProvider.new(path).setup
        end
      end
    end
  end
end
