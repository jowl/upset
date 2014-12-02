# encoding: utf-8

require 'spec_helper'
require 'support/provider_shared'

module Upset
  module Provision
    describe Provider do
      let :provider do
        described_class.new
      end

      it_behaves_like 'a provider' do
        let :properties do
          {}
        end
      end

      describe '#setup' do
        it 'returns self' do
          expect(provider.setup).to eq(provider)
        end
      end
    end
  end
end
