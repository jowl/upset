# encoding: utf-8

require 'spec_helper'

module Upset
  module Transformation
    describe DeepFreeze do
      let :deep_freeze do
        described_class.new
      end

      let :value do
        'value'
      end

      let :frozen_value do
        deep_freeze.call(value)
      end

      describe '#call' do
        it 'returns a frozen value' do
          expect(frozen_value).to be_frozen
        end

        it "doesn't duplicate the value" do
          expect(frozen_value).to equal(value)
        end

        context 'with Hash values' do
          let :value do
            { 'alpha' => 'A', 'beta' => 'B' }
          end

          it 'ensures that all keys and values are frozen' do
            expect(frozen_value).not_to be_empty
            frozen_value.each do |key, value|
              expect(key).to be_frozen
              expect(value).to be_frozen
            end
          end
        end

        context 'with Array values' do
          let :value do
            %w[alpha beta]
          end

          it 'ensures that all entries are frozen' do
            expect(frozen_value).not_to be_empty
            expect(frozen_value).to all be_frozen
          end
        end
      end
    end
  end
end
