# encoding: utf-8

require 'spec_helper'

module Upset
  describe Property do
    let :provider do
      double(:provider)
    end

    let :value do
      'value'
    end

    let :property do
      described_class.new(provider, 'key', value)
    end

    describe '#value' do
      it 'returns frozen values' do
        expect(property.value).to be_frozen
      end

      it "doesn't duplicate values" do
        expect(property.value).to equal(value)
      end

      context 'with Hash values' do
        let :value do
          { 'alpha' => 'A', 'beta' => 'B' }
        end

        it 'ensures all keys and values are frozen' do
          expect(property.value).not_to be_empty
          property.value.each do |key, value|
            expect(key).to be_frozen
            expect(value).to be_frozen
          end
        end
      end

      context 'with Array values' do
        let :value do
          %w[alpha beta]
        end

        it 'ensures all entries are frozen' do
          expect(property.value).not_to be_empty
          expect(property.value).to all be_frozen
        end
      end
    end
  end
end
