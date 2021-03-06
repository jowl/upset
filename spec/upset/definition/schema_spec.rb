# encoding: utf-8

require 'spec_helper'
require 'support/spec_constraints'

module Upset
  module Definition
    describe Schema do
      let :property_definitions do
        {
          'alpha' => ValueProperty.new(ValidConstraint.new, false),
          'beta' => ValueProperty.new(ValidConstraint.new, true),
        }
      end

      let :schema do
        described_class.new(property_definitions)
      end

      let :configuration do
        { 'alpha' => 1, 'beta' => 2 }
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
          property_definitions.merge!('alpha' => ValueProperty.new(SpecConstraints::InvalidConstraint.new, true))
          expect(schema.validate(configuration)).not_to be_valid
        end

        it 'returns an invalid result when an optional property fails to satisfy its constraint' do
          property_definitions.merge!('beta' => ValueProperty.new(SpecConstraints::InvalidConstraint.new, false))
          expect(schema.validate(configuration)).not_to be_valid
        end

        context 'when there is a default property definition' do
          let :configuration do
            super().merge('gamma' => nil)
          end

          it 'returns a valid result when all undefined properties satisfies the default constraint' do
            property_definitions.default = ValueProperty.new(ValidConstraint.new, true)
            expect(schema.validate(configuration)).to be_valid
          end

          it "returns an invalid result when any undefined property fails to satisfy the default constraint" do
            property_definitions.default = ValueProperty.new(SpecConstraints::InvalidConstraint.new, true)
            expect(schema.validate(configuration)).not_to be_valid
          end
        end
      end
    end
  end
end
