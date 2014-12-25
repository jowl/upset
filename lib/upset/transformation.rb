# encoding: utf-8

module Upset
  module Transformation
    class Transformer
      def initialize(provider, transformations)
        @provider = provider
        @transformations = transformations
      end

      def [](key)
        if (property = @provider[key])
          if (transformation = @transformations[key])
            TransformedProperty.new(property, transformation)
          else
            property
          end
        end
      end

      def keys
        @provider.keys
      end

      def has_key?(key)
        @provider.has_key?(key)
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
