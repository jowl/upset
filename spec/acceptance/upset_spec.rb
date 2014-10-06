# encoding: utf-8

require 'spec_helper'

module Upset
  describe self do
    let :default_properties do
      {
        'alpha' => 'omega',
        'beta' => 42,
      }
    end

    let :default_provider do
      Provision::SimpleProvider.new(default_properties)
    end

    let :configuration do
      Configuration.new(default_provider)
    end

    describe Configuration do
      before do
        configuration.providers << Provision::SimpleProvider.new('beta' => 43)
      end

      it 'prefers the latest added Provider' do
        expect(configuration['beta']).to eq(43)
      end

      it 'falls back on the default Provider' do
        expect(configuration['alpha']).to eq('omega')
      end

      context 'when merging different Providers' do
        before do
          configuration.providers << Provision::SimpleProvider.new('gamma' => {'a' => {'A' => 1, 'B' => 2}})
          configuration.providers << Provision::SimpleProvider.new('gamma' => {'a' => {'B' => 3, 'C' => 4}, 'b' => {}})
        end

        it 'does deep merges' do
          expect(configuration['gamma']).to eq('a' => {'A' => 1, 'B' => 3, 'C' => 4}, 'b' => {})
        end
      end
    end

    describe Definition do
      let :property_definitions do
        {
          'alpha' => PropertyDefinition.new(Constraint::Regexp.new(/omega/i), true),
          'beta' => PropertyDefinition.new(Constraint::Kind.new(Fixnum), true),
          'gamma' => PropertyDefinition.new(Constraint::Valid.new, false),
        }
      end

      let :definition do
        Definition.new(property_definitions)
      end

      it 'is possible to validate the Configuration' do
        expect { definition.validate(configuration) }.not_to raise_error
      end
    end
  end
end
