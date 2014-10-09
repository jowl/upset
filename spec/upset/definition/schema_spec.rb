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
  module Definition
    describe Schema do
      let :property_definitions do
        {
          'alpha' => ValueDefinition.new(ValidConstraint.new, false),
          'beta' => ValueDefinition.new(ValidConstraint.new, true),
        }
      end

      let :schema do
        described_class.new(property_definitions)
      end

      let :configuration do
        FakeConfiguration.new('alpha' => 1, 'beta' => 2)
      end

      describe '#validate' do
        it 'can return a valid result' do
          expect(schema.validate(configuration)).to be_valid
        end

        it 'returns an invalid result a required property is missing' do
          configuration.delete('alpha')
          expect(schema.validate(configuration)).not_to be_valid
        end

        it 'returns a valid result when an optional property is missing' do
          configuration.delete('beta')
          expect(schema.validate(configuration)).to be_valid
        end

        it "returns an invalid result when a property isn't required nor optional" do
          configuration.merge!('gamma' => 3)
          expect(schema.validate(configuration)).not_to be_valid
        end

        it 'returns an invalid result when a required property fails to satisfy its constraint' do
          property_definitions.merge!('alpha' => ValueDefinition.new(SpecConstraints::InvalidConstraint.new, true))
          expect(schema.validate(configuration)).not_to be_valid
        end

        it 'returns an invalid result when an optional property fails to satisfy its constraint' do
          property_definitions.merge!('beta' => ValueDefinition.new(SpecConstraints::InvalidConstraint.new, false))
          expect(schema.validate(configuration)).not_to be_valid
        end
      end

      describe '#describe' do
      end
    end
  end
end
