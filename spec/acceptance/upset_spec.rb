# encoding: utf-8

require 'spec_helper'

module Upset
  describe self do
    let :provider do
      Provision::Provider.new('alpha' => 'omega', 'beta' => 42)
    end

    let :configuration do
      Configuration.new(provider)
    end

    describe Transformation do
      let :transformer do
        Transformation::Transformer.new(Provision::Provider.new('beta' => 'psi'), 'beta' => Transformation::DeepFreezer.new)
      end

      before do
        configuration.providers.unshift(transformer)
      end

      it 'returns transformed properties' do
        expect(configuration['alpha']).not_to be_frozen
        expect(configuration['beta']).to be_frozen
      end
    end

    describe Configuration do
      before do
        configuration.providers.unshift(Provision::Provider.new('beta' => 43))
      end

      it 'prefers the first Provider' do
        expect(configuration['beta']).to eq(43)
      end

      it 'falls back on the next Provider' do
        expect(configuration['alpha']).to eq('omega')
      end
    end

    describe Definition do
      let :property_definitions do
        {
          'alpha' => Definition::ValueProperty.new(Definition::RegexpConstraint.new(/omega/i), false),
          'beta' => Definition::ValueProperty.new(Definition::KindConstraint.new(Fixnum), false),
          'gamma' => Definition::ValueProperty.new(Definition::ValidConstraint.new, true),
        }
      end

      let :schema do
        Definition::Schema.new(property_definitions)
      end

      it 'is possible to validate the Configuration' do
        expect(schema.validate(configuration)).to be_valid
      end
    end
  end
end
