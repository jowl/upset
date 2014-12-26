# encoding: utf-8

require 'spec_helper'
require 'support/provider_common'

module Upset
  module Transformation
    describe Transformer do
      let :provider do
        Provision::Provider.new('alpha' => 1, 'beta' => 2)
      end

      let :add_one do
        proc { |value| value + 1 }
      end

      let :transformer do
        described_class.new(provider, 'beta' => add_one)
      end

      describe '#[]' do
        context 'returns a TransformedProperty that' do
          before do
            expect(transformer['beta']).to be_a(TransformedProperty)
          end

          it 'exposes the transformed value' do
            expect(transformer['beta'].value).to eq(3)
          end

          it 'exposes the raw value' do
            expect(transformer['beta'].raw_value).to eq(2)
          end

          it 'exposes the transformation' do
            expect(transformer['beta'].transformation).to equal(add_one)
          end
        end

        context 'when no transformation is specified, returns a Property that' do
          before do
            expect(transformer['alpha']).to be_a(Property)
          end

          it "hasn't been transformed" do
            expect(transformer['alpha'].value).to eq(provider['alpha'].value)
          end
        end
      end

      context 'it behaves like a Provider' do
        include_examples 'provider_common' do
          let :properties do
            {
              'alpha' => 1,
              'beta' => 2,
            }
          end

          let :provider do
            described_class.new(Provision::Provider.new(properties), {})
          end
        end
      end
    end
  end
end
