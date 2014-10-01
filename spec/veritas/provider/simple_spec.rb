# encoding: utf-8

require 'spec_helper'
require 'support/provider_shared'

module Veritas
  class Provider
    describe Simple do
      let :properties do
        {
          'alpha' => 1,
          'bravo' => 2,
        }
      end

      let :provider do
        described_class.new(properties)
      end

      it_behaves_like 'a provider' do
        let :expected_properties do
          properties.dup
        end
      end

      describe '#reload' do
        it "doesn't do anything" do
          expect do
            properties.merge!('caesar' => 3)
            provider.reload
          end.not_to change(provider, :to_h)
        end
      end
    end
  end
end
