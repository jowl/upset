# encoding: utf-8

require 'spec_helper'
require 'support/provider_common'

module Upset
  module Provision
    describe Provider do
      let :properties do
        {
          'alpha' => 1,
          'beta' => 2,
        }
      end

      let :provider do
        described_class.new(properties)
      end

      include_examples 'provider_common'

      it "doesn't duplicate properties" do
        expect { properties.merge!('gamma' => 3) }.to change(provider, :keys)
      end
    end
  end
end
