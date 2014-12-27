# encoding: utf-8

module Upset
  module Provision
    module Dsl
      module Transformations
        def deep_freeze(*keys)
          add_transformation(Upset::Transformation::DeepFreezer.new, keys)
        end

        def parse_integer(*keys)
          add_transformation(Upset::Transformation::IntegerParser.new, keys)
        end

        def parse_float(*keys)
          add_transformation(Upset::Transformation::FloatParser.new, keys)
        end

        def parse_boolean(*keys)
          add_transformation(Upset::Transformation::BooleanParser.new, keys)
        end

        def transform(*keys, &transformation)
          add_transformation(transformation, keys)
        end
      end
    end
  end
end
