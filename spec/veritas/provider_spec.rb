# encoding: utf-8

require 'spec_helper'
require 'support/provider_shared'

module Veritas
  describe Provider do
    let :provider do
      described_class.new
    end

    it_behaves_like 'a provider' do
      let :expected_properties do
        {}
      end
    end

    describe '#reload' do
      it 'returns self' do
        expect(provider.reload).to eq(provider)
      end
    end
  end
end
