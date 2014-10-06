# encoding: utf-8

require 'spec_helper'
require 'support/spec_constraints'

class FakeConfiguration < Hash
  def initialize(properties)
    replace(properties)
  end
  alias :has_property? :has_key?
  alias :properties :keys
end

module Upset
  describe Definition do
    let :property_definitions do
      {
        'alpha' => PropertyDefinition.new(described_class::ValidConstraint.new, true),
        'beta' => PropertyDefinition.new(described_class::ValidConstraint.new, false),
      }
    end

    let :definition do
      described_class.new(property_definitions)
    end

    let :configuration do
      FakeConfiguration.new('alpha' => 1, 'beta' => 2)
    end

    describe '#validate' do
      it "doesn't always raise errors" do
        expect { definition.validate(configuration) }.not_to raise_error
      end

      it 'raises MissingPropertyError when a required property is missing' do
        configuration.delete('alpha')
        expect { definition.validate(configuration) }.to raise_error(MissingPropertyError, /missing.+alpha/i)
      end

      it "doesn't raise error when an optional property is missing" do
        configuration.delete('beta')
        expect { definition.validate(configuration) }.not_to raise_error
      end

      it "raises UnknownPropertyError when a property isn't required nor optional" do
        configuration.merge!('gamma' => 3)
        expect { definition.validate(configuration) }.to raise_error(UnknownPropertyError, /unknown.+gamma/i)
      end

      it 'raises InvalidPropertyError when a required property fails to satisfy its constraint' do
        property_definitions.merge!('alpha' => PropertyDefinition.new(SpecConstraints::Invalid.new, true))
        expect { definition.validate(configuration) }.to raise_error(InvalidPropertyError, /invalid property.+alpha/i)
      end

      it 'raises InvalidPropertyError when an optional property fails to satisfy its constraint' do
        property_definitions.merge!('beta' => PropertyDefinition.new(SpecConstraints::Invalid.new, false))
        expect { definition.validate(configuration) }.to raise_error(InvalidPropertyError, /invalid property.+beta/i)
      end
    end

    describe '#describe' do
    end
  end
end
