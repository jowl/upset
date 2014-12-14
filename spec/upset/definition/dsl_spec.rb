# encoding: utf-8

require 'spec_helper'
require 'tempfile'

module Upset
  module Definition
    describe Dsl do
      def schema(&block)
        Class.new.class_exec(described_class) do |dsl_module|
          include dsl_module
          schema(&block)
        end.new
      end

      describe '#schema' do
        describe '#required_property' do
          let :validator do
            schema do
              required_property 'alpha'
            end
          end

          it 'adds a required property' do
            expect(validator.validate('alpha' => nil)).to be_valid
            expect(validator.validate({})).not_to be_valid
          end
        end

        describe '#optional_property' do
          let :validator do
            schema do
              optional_property 'alpha'
            end
          end

          it 'adds an optional property' do
            expect(validator.validate({})).to be_valid
            expect(validator.validate('alpha' => nil)).to be_valid
          end
        end

        describe '#default' do
          let :validator do
            schema do
              default is_a(String)
            end
          end

          it 'sets a default property definition' do
            expect(validator.validate({})).to be_valid
            expect(validator.validate('alpha' => 'A')).to be_valid
            expect(validator.validate('alpha' => nil)).not_to be_valid
          end
        end

        context 'with constraints' do
          describe '#is_a' do
            let :validator do
              schema do
                required_property 'alpha', is_a(String)
              end
            end

            it 'creates KindConstraint' do
              expect(validator.validate('alpha' => 'A')).to be_valid
              expect(validator.validate('alpha' => nil)).not_to be_valid
            end
          end

          describe '#matches' do
            let :validator do
              schema do
                required_property 'alpha', matches(/[A-Z]+/)
              end
            end

            it 'creates RegexpConstraint' do
              expect(validator.validate('alpha' => 'ABC')).to be_valid
              expect(validator.validate('alpha' => 'abc')).not_to be_valid
            end
          end

          describe '#is_a_file' do
            let :validator do
              schema do
                required_property 'alpha', is_a_file
              end
            end

            let :file do
              Tempfile.new('some-file')
            end

            after do
              file.close
              file.unlink
            end

            it 'creates FileConstraint' do
              expect(validator.validate('alpha' => file.path)).to be_valid
              expect(validator.validate('alpha' => '/not/a/file')).not_to be_valid
            end
          end

          describe '#is_between' do
            let :validator do
              schema do
                required_property 'alpha', is_between(1, 3)
              end
            end

            it 'creates RangeConstraint' do
              expect(validator.validate('alpha' => 0)).not_to be_valid
              expect(validator.validate('alpha' => 2)).to be_valid
              expect(validator.validate('alpha' => 4)).not_to be_valid
            end
          end

          describe '#is_above' do
            let :validator do
              schema do
                required_property 'alpha', is_above(1)
              end
            end

            it 'creates RangeConstraint' do
              expect(validator.validate('alpha' => 0)).not_to be_valid
              expect(validator.validate('alpha' => 1)).to be_valid
            end
          end

          describe '#is_below' do
            let :validator do
              schema do
                required_property 'alpha', is_below(3)
              end
            end

            it 'creates RangeConstraint' do
              expect(validator.validate('alpha' => 3)).to be_valid
              expect(validator.validate('alpha' => 4)).not_to be_valid
            end
          end

          describe '#each_member' do
            let :validator do
              schema do
                required_property 'alpha', each_member(is_an(Integer))
              end
            end

            it 'creates MemberConstraint' do
              expect(validator.validate('alpha' => [1, 2, 3])).to be_valid
              expect(validator.validate('alpha' => [1, nil, 3])).not_to be_valid
            end
          end

          describe '#either' do
            let :validator do
              schema do
                required_property 'alpha', either(is_a(String), is_a(NilClass))
              end
            end

            it 'creates DisjunctiveConstraint' do
              expect(validator.validate('alpha' => nil)).to be_valid
              expect(validator.validate('alpha' => 'A')).to be_valid
              expect(validator.validate('alpha' => 1)).not_to be_valid
            end
          end

          describe '#both' do
            let :validator do
              schema do
                required_property 'alpha', both(matches(/^A/), matches(/Z$/))
              end
            end

            it 'creates ConjunctiveConstraint' do
              expect(validator.validate('alpha' => 'A-Z')).to be_valid
              expect(validator.validate('alpha' => 'B-Z')).not_to be_valid
              expect(validator.validate('alpha' => 'A-Y')).not_to be_valid
            end
          end
        end

        context 'when nesting schemas' do
          let :validator do
            schema do
              optional_property 'alpha' do
                required_property 'beta'
              end
            end
          end

          it 'adds definitions for nested properties' do
            expect(validator.validate('alpha' => { })).not_to be_valid
            expect(validator.validate('alpha' => { 'beta' => nil })).to be_valid
          end
        end

        context 'when nesting schemas and defining constraints' do
          let :validator do
            schema do
              optional_property('alpha', is_a(String)) {}
            end
          end

          it 'raises SchemaError' do
            expect { validator }.to raise_error(described_class::SchemaError)
          end
        end

        context 'when called multiple times' do
          let :validator do
            Class.new.class_exec(described_class) do |dsl_module|
              include dsl_module
              schema { required_property 'alpha' }
              schema { required_property 'beta' }
            end.new
          end

          it 'combines the definitions' do
            expect(validator.validate('alpha' => nil)).not_to be_valid
            expect(validator.validate('beta' => nil)).not_to be_valid
            expect(validator.validate('alpha' => nil, 'beta' => nil)).to be_valid
          end
        end

        context 'when subclassing' do
          let :validator_class do
            superclass = Class.new.class_exec(described_class) do |dsl_module|
              include dsl_module
              schema { required_property 'alpha' }
            end
            Class.new(superclass).class_exec do
              schema { required_property 'beta' }
            end
          end

          it 'inherits the definitions' do
            validator = validator_class.new
            expect(validator.validate('alpha' => nil)).not_to be_valid
            expect(validator.validate('beta' => nil)).not_to be_valid
            expect(validator.validate('alpha' => nil, 'beta' => nil)).to be_valid
          end

          it "doesn't change the superclass' schema" do
            validator = validator_class.superclass.new
            expect(validator.validate('alpha' => nil)).to be_valid
            expect(validator.validate('beta' => nil)).not_to be_valid
            expect(validator.validate('alpha' => nil, 'beta' => nil)).not_to be_valid
          end
        end
      end
    end
  end
end
