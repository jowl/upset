# encoding: utf-8

require 'spec_helper'

module Upset
  describe self do
    let :default_provider do
      Provision::Provider.new('alpha' => 'omega', 'beta' => 42)
    end

    let :configuration do
      Configuration.new(default_provider)
    end

    describe Configuration do
      before do
        configuration.providers << Provision::Provider.new('beta' => 43)
      end

      it 'prefers the latest added Provider' do
        expect(configuration['beta']).to eq(43)
      end

      it 'falls back on the default Provider' do
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
