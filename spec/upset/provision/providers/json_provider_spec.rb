# encoding: utf-8

require 'spec_helper'
require 'support/provider_common'
require 'tempfile'

module Upset
  module Provision
    describe JsonProvider do
      let :properties do
        {
          'alpha' => 1,
          'beta' => 2,
        }
      end

      let :file do
        Tempfile.new('spec-config.json')
      end

      let :provider do
        described_class.new(file.path).setup
      end

      before do
        file.write(properties.to_json)
        file.flush
      end

      include_examples 'provider_common'

      describe '#setup' do
        it "re-reads config file" do
          expect do
            file.rewind
            file.write(properties.merge('gamma' => 3).to_json)
            file.flush
            provider.setup
          end.to change(provider, :keys)
        end
      end
    end
  end
end
