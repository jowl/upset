# encoding: utf-8

module Upset
  class Definition
    def initialize(required, optional)
      @required = required
      @optional = optional
    end

    def validate(configuration)
      missing = @required - configuration.keys
      if !missing.empty?
        raise MissingParameterError.new('Missing parameter(s): %s' % missing.map(&:inspect).join(', '))
      end
      unknown = configuration.keys - (@required + @optional)
      if !unknown.empty?
        raise UnknownParameterError.new('Unknown parameter(s): %s' % unknown.map(&:inspect).join(', '))
      end
      true
    end

    def describe
    end
  end

  ValidationError = Class.new(UpsetError)
  MissingParameterError = Class.new(ValidationError)
  UnknownParameterError = Class.new(ValidationError)
end
