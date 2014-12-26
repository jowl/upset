# encoding: utf-8

require 'spec_helper'
require 'tempfile'

module Upset
  module Provision
    describe Dsl do
      def provision(*args, &block)
        Class.new(Configuration).class_exec(described_class, *args) do |dsl_module, *args|
          extend dsl_module
          provision(*args, &block)
        end.create
      end

      describe '#provision' do
        context 'with providers' do
          it 'prioritizes them descendingly' do
            configuration = provision do
              properties 'alpha' => 1
              properties 'alpha' => 2, 'beta' => 2
              properties 'beta' => 3
            end
            expect(configuration['alpha']).to eq(1)
            expect(configuration['beta']).to eq(2)
          end

          describe '#properties' do
            let :configuration do
              provision do
                properties 'alpha' => 'A'
              end
            end

            it 'creates a Provider' do
              expect(configuration['alpha']).to eq('A')
            end
          end

          describe '#yaml' do
            let :file do
              Tempfile.new('file.yaml')
            end

            before do
              file.puts('alpha: A')
              file.flush
            end

            after do
              file.close
              file.unlink
            end

            let :configuration do
              provision(file) do |file|
                yaml file.path
              end
            end

            it 'creates a YamlProvider' do
              expect(configuration['alpha']).to eq('A')
            end
          end
        end
      end
    end
  end
end
