# encoding: utf-8

module Upset
  module Transformation
    class DeepFreeze
      def call(object)
        object.each(&method(:call)) if object.is_a?(Enumerable)
        object.freeze
      end
    end
  end
end
