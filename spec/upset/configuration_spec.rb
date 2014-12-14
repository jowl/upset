# encoding: utf-8

require 'spec_helper'

module Upset
  describe Configuration do
    def provide(properties)
      Provision::Provider.new(properties)
    end

    let :default_provider do
      provide('alpha' => [], 'beta' => false, 'gamma' => {})
    end

    let :configuration do
      described_class.new(default_provider)
    end

    describe '#[]' do
      let :default_provider do
        provide('alpha' => :a1, 'beta' => :a2, 'gamma' => :a3)
      end

      let :providers do
        [provide('alpha' => :b1, 'beta' => :b2), provide('alpha' => :c1)]
      end

      before do
        configuration.providers = providers
      end

      it 'returns the first found property value from the providers' do
        expect(configuration['alpha']).to eq(:c1)
        expect(configuration['beta']).to eq(:b2)
        expect(configuration['gamma']).to eq(:a3)
      end

      it 'returns nil for unknown properties' do
        expect(configuration['delta']).to be_nil
      end
    end

    describe '#fetch' do
      it 'returns a property value from a provider' do
        expect(configuration.fetch('alpha', 1)).to eq([])
      end

      it 'returns a property value from a provider, even if falsy' do
        expect(configuration.fetch('beta', 1)).to eq(false)
      end

      context 'when the property is unknown' do
        it 'raises KeyError without default and block' do
          expect { configuration.fetch('delta') }.to raise_error(KeyError)
        end

        it 'returns the result from the block' do
          expect(configuration.fetch('delta') { 1 }).to eq(1)
        end

        it 'returns the default value' do
          expect(configuration.fetch('delta', 1)).to eq(1)
        end

        it 'choses the block over the default value' do
          expect(configuration.fetch('delta', 1) { 2 }).to eq(2)
        end
      end
    end

    describe '#property' do
      it 'returns a Property for existing properties' do
        expect(configuration.property('alpha')).to be_a(Property)
      end

      it 'returns nil for unknown properties' do
        expect(configuration.property('delta')).to be_nil
      end
    end

    describe '#has_property?' do
      it 'returns true if the given property is defined in the default provider' do
        expect(configuration).to have_property('alpha')
      end

      it 'returns true if the given property is defined in another provider' do
        configuration.providers = [provide('delta' => nil)]
        expect(configuration).to have_property('delta')
      end

      it 'returns false if the given property is not defined' do
        expect(configuration).not_to have_property('omega')
      end
    end

    describe '#properties' do
      before do
        configuration.providers << provide('gamma' => nil, 'delta' => nil)
      end

      it 'returns a list of all known properties' do
        expect(configuration.properties).to contain_exactly('alpha', 'beta', 'gamma', 'delta')
      end
    end
  end
end
