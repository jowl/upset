# encoding: utf-8

require 'spec_helper'
require 'tempfile'

module Upset
  module Provision
    describe Dsl do
      def provision(*args, &block)
        Class.new(Configuration).class_exec(described_class, *args) do |dsl_module, *args|
          include dsl_module
          provision(*args, &block)
        end.create
      end

      describe '#provision' do
        it 'prioritizes the providers ascendingly' do
          configuration = provision do
            properties 'alpha' => 1
            properties 'alpha' => 2, 'beta' => 2
            properties 'beta' => 3
          end
          expect(configuration['alpha']).to eq(2)
          expect(configuration['beta']).to eq(3)
        end

        context 'with providers' do
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

          describe '#json' do
            let :file do
              Tempfile.new('file.json')
            end

            before do
              file.puts('{"alpha":"A"}')
              file.flush
            end

            after do
              file.close
              file.unlink
            end

            let :configuration do
              provision(file) do |file|
                json file.path
              end
            end

            it 'creates a JsonProvider' do
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

        context 'with transformers' do
          context 'and key constraints' do
            describe '#all' do
              let :configuration do
                provision do
                  properties 'alpha' => '1', 'beta' => '2' do
                    parse_integer all
                  end
                end
              end

              it 'applies transformation to all properties' do
                expect(configuration['alpha']).to eq(1)
                expect(configuration['beta']).to eq(2)
              end
            end

            context 'with specific keys' do
              let :configuration do
                provision do
                  properties 'alpha' => '1', 'beta' => '2', 'gamma' => '3' do
                    parse_integer 'alpha', 'gamma'
                  end
                end
              end

              it 'only applies transformation the specified properties' do
                expect(configuration['alpha']).to eq(1)
                expect(configuration['beta']).to eq('2')
                expect(configuration['gamma']).to eq(3)
              end
            end
          end

          describe '#deep_freeze' do
            let :configuration do
              provision do
                properties 'alpha' => ['A'] do
                  deep_freeze all
                end
              end
            end

            it 'creates a DeepFreezer' do
              expect(configuration['alpha']).to be_frozen
              expect(configuration['alpha']).to all be_frozen
            end
          end

          describe '#parse_integer' do
            let :configuration do
              provision do
                properties 'alpha' => '1' do
                  parse_integer all
                end
              end
            end

            it 'creates an IntegerParser' do
              expect(configuration['alpha']).to eq(1)
            end
          end

          describe '#parse_float' do
            let :configuration do
              provision do
                properties 'alpha' => '1.5' do
                  parse_float all
                end
              end
            end

            it 'creates a FloatParser' do
              expect(configuration['alpha']).to eq(1.5)
            end
          end

          describe '#parse_boolean' do
            let :configuration do
              provision do
                properties('alpha' => 'true') do
                  parse_boolean all
                end
              end
            end

            it 'creates a BooleanParser' do
              expect(configuration['alpha']).to eq(true)
            end
          end

          describe '#transform' do
            let :configuration do
              provision do
                properties 'alpha' => 1 do
                  transform all do |value|
                    value * 2
                  end
                end
              end
            end

            it 'creates a custom transformation' do
              expect(configuration['alpha']).to eq(2)
            end
          end
        end

        context 'when called multiple times' do
          let :configuration do
            Class.new(Configuration).class_exec(described_class) do |dsl_module|
              include dsl_module
              provision { properties 'alpha' => 1 }
              provision { properties 'beta' => 2 }
            end.create
          end

          it 'concatinates the providers' do
            expect(configuration['alpha']).to eq(1)
            expect(configuration['beta']).to eq(2)
          end
        end

        context 'when subclassing' do
          let :configuration_class do
            superclass = Class.new(Configuration).class_exec(described_class) do |dsl_module|
              include dsl_module
              provision { properties 'alpha' => 1 }
            end
            Class.new(superclass).class_exec do
              provision { properties 'beta' => 2 }
            end
          end

          it 'inherits the providers' do
            configuration = configuration_class.create
            expect(configuration['alpha']).to eq(1)
            expect(configuration['beta']).to eq(2)
          end

          it "doesn't change the superclass' providers" do
            configuration = configuration_class.superclass.create
            expect(configuration['alpha']).to eq(1)
            expect(configuration['beta']).to be_nil
          end
        end
      end
    end
  end
end
