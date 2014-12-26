# encoding: utf-8

require 'upset/provision'

module Upset
  module Transformation
    class Transformer < Provision::Provider
      def initialize(provider, transformations)
        self.properties = provider
        @transformations = transformations
      end

      def [](key)
        if (property = get(key))
          if (transformation = @transformations[key])
            TransformedProperty.new(property, transformation)
          else
            property
          end
        end
      end
    end
  end

  class TransformedProperty < Property
    attr_reader :transformation, :raw_value
    def initialize(property, transformation)
      @transformation = transformation
      @raw_value = property.value
      super(property.provider, property.key, transformation.call(property.value))
    end
  end
end

require 'upset/transformation/deep_freezer'
require 'upset/transformation/parsers'
