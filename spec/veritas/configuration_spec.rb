# encoding: utf-8

require 'spec_helper'

module Veritas
  describe Configuration do
    let :configuration do
      described_class.new(default_provider)
    end

    describe '#[]' do
      let :default_provider do
        { 'alpha' => :a1, 'beta' => :a2, 'caesar' => :a3}
      end

      let :providers do
        [{'alpha' => :b1, 'beta' => :b2}, {'alpha' => :c1}]
      end

      before do
        configuration.providers = providers.dup
      end

      it 'returns the first found property value from the providers' do
        expect(configuration['alpha']).to eq(:c1)
        expect(configuration['beta']).to eq(:b2)
        expect(configuration['caesar']).to eq(:a3)
      end

      it 'returns nil for unknown properties' do
        expect(configuration['delta']).to be_nil
      end

      it 'returns deep frozen values' do
        deep_frozen = proc do |obj|
          obj.frozen? && (!obj.is_a?(Enumerable) || (obj.is_a?(Hash) ? obj.values : obj).all?(&deep_frozen))
        end
        configuration.providers << { 'alpha' => [{'ALPHA' => ['A', 1]}, 'BETA'] }
        expect(configuration['alpha']).to satisfy(&deep_frozen)
      end

      it 'deep merges Hash values' do
        configuration.providers << {'alpha' => {'ALPHA' => {'a' => 1}}}
        configuration.providers << {'alpha' => {'ALPHA' => {'b' => 2}}}
        expect(configuration['alpha']).to eq('ALPHA' => {'a' => 1, 'b' => 2})
      end

      context 'when providers change' do
        before do
          configuration['alpha']
        end

        it 'detects if new providers are added to the list' do
          configuration.providers << { 'alpha' => :d1 }
          expect(configuration['alpha']).to eq(:d1)
        end

        it 'detects if providers are removed from the list' do
          configuration.providers.pop
          expect(configuration['alpha']).to eq(:b1)
        end

        it 'detects if a provider is mutated' do
          configuration.providers.last.merge!('beta' => :c2)
          expect(configuration['alpha']).to eq(:c1)
        end
      end
    end


    describe '#reload' do
      let :default_provider do
        double(:provider, reload: nil)
      end

      let :providers do
        3.times.map { double(:provider, reload: nil) }
      end

      it 'returns self' do
        expect(configuration.reload).to eq(configuration)
      end

      it 'reloads the default provider' do
        configuration.reload
        expect(default_provider).to have_received(:reload)
      end

      it 'reloads all providers' do
        configuration.providers = providers.dup
        configuration.reload
        expect(providers).to all have_received(:reload)
      end
    end
  end
end
