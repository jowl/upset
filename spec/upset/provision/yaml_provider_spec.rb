# encoding: utf-8

require 'spec_helper'
require 'support/provider_shared'
require 'tempfile'

module Upset
  module Provision
    describe YamlProvider do
      let :properties do
        {
          'alpha' => 1,
          'beta' => 2,
        }
      end

      let :file do
        Tempfile.new('spec-config.yml')
      end

      let :provider do
        described_class.new(file.path).setup
      end

      it_behaves_like 'a provider'

      before do
        file.write(properties.to_yaml)
        file.flush
      end

      describe '#setup' do
        it "re-reads config file" do
          properties.each do |property, value|
            expect(provider[property].value).to eq(value)
          end
          new_properties = properties.merge('gamma' => 3)
          file.rewind
          file.write(new_properties.to_yaml)
          file.flush
          provider.setup
          new_properties.each do |property, value|
            expect(provider[property].value).to eq(value)
          end
        end
      end
    end
  end
end
