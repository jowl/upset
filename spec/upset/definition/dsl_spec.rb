# encoding: utf-8

require 'spec_helper'
require 'tempfile'

module Upset
  module Definition
    describe Dsl do
      def definition(&block)
        Class.new.class_exec(described_class) do |dsl_module|
          include dsl_module
          definition(&block)
        end.new
      end

      describe '#definition' do
        describe '#required_property' do
          let :validator do
            definition do
              required 'alpha'
            end
          end

          it 'adds a required property' do
            expect(validator.validate('alpha' => nil)).to be_valid
            expect(validator.validate({})).not_to be_valid
          end
        end

        describe '#optional' do
          let :validator do
            definition do
              optional 'alpha'
            end
          end

          it 'adds an optional property' do
            expect(validator.validate({})).to be_valid
            expect(validator.validate('alpha' => nil)).to be_valid
          end
        end

        describe '#residual' do
          let :validator do
            definition do
              residual.is a(String)
            end
          end

          it 'sets a default property definition' do
            expect(validator.validate({})).to be_valid
            expect(validator.validate('alpha' => 'A')).to be_valid
            expect(validator.validate('alpha' => nil)).not_to be_valid
          end
        end

        context 'with constraints' do
          describe '#a' do
            let :validator do
              definition do
                required('alpha').is a(String)
              end
            end

            it 'creates KindConstraint' do
              expect(validator.validate('alpha' => 'A')).to be_valid
              expect(validator.validate('alpha' => nil)).not_to be_valid
            end
          end

          describe '#matching' do
            let :validator do
              definition do
                required('alpha').is matching(/[A-Z]+/)
              end
            end

            it 'creates RegexpConstraint' do
              expect(validator.validate('alpha' => 'ABC')).to be_valid
              expect(validator.validate('alpha' => 'abc')).not_to be_valid
            end
          end

          describe '#a_file' do
            let :validator do
              definition do
                required('alpha').is a_file
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

          describe '#between' do
            let :validator do
              definition do
                required('alpha').is between 1, 3
              end
            end

            it 'creates RangeConstraint' do
              expect(validator.validate('alpha' => 0)).not_to be_valid
              expect(validator.validate('alpha' => 2)).to be_valid
              expect(validator.validate('alpha' => 4)).not_to be_valid
            end
          end

          describe '#above' do
            let :validator do
              definition do
                required('alpha').is above 1
              end
            end

            it 'creates RangeConstraint' do
              expect(validator.validate('alpha' => 0)).not_to be_valid
              expect(validator.validate('alpha' => 1)).to be_valid
            end
          end

          describe '#below' do
            let :validator do
              definition do
                required('alpha').is below 3
              end
            end

            it 'creates RangeConstraint' do
              expect(validator.validate('alpha' => 3)).to be_valid
              expect(validator.validate('alpha' => 4)).not_to be_valid
            end
          end

          describe '#a_positive_integer' do
            let :validator do
              definition do
                required('alpha').is a_positive_integer
              end
            end

            it 'creates RangeConstraint' do
              expect(validator.validate('alpha' => -1)).not_to be_valid
              expect(validator.validate('alpha' => 0)).not_to be_valid
              expect(validator.validate('alpha' => 1)).to be_valid
              expect(validator.validate('alpha' => 1.0)).not_to be_valid
            end
          end

          describe '#all' do
            let :validator do
              definition do
                required('alpha').are all an(Integer)
              end
            end

            it 'creates MemberConstraint' do
              expect(validator.validate('alpha' => [1, 2, 3])).to be_valid
              expect(validator.validate('alpha' => [1, nil, 3])).not_to be_valid
            end
          end

          describe '#either' do
            let :validator do
              definition do
                required('alpha').is either a(String), a(NilClass)
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
              definition do
                required('alpha').is both matching(/^A/), matching(/Z$/)
              end
            end

            it 'creates ConjunctiveConstraint' do
              expect(validator.validate('alpha' => 'A-Z')).to be_valid
              expect(validator.validate('alpha' => 'B-Z')).not_to be_valid
              expect(validator.validate('alpha' => 'A-Y')).not_to be_valid
            end
          end
        end

        context 'when nesting definitions' do
          let :validator do
            definition do
              optional 'alpha' do
                required 'beta'
              end
            end
          end

          it 'adds definitions for nested properties' do
            expect(validator.validate('alpha' => { })).not_to be_valid
            expect(validator.validate('alpha' => { 'beta' => nil })).to be_valid
          end
        end

        context 'when called multiple times' do
          let :validator do
            Class.new.class_exec(described_class) do |dsl_module|
              include dsl_module
              definition { required 'alpha' }
              definition { required 'beta' }
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
              definition { required 'alpha' }
            end
            Class.new(superclass).class_exec do
              definition { required 'beta' }
            end
          end

          it 'inherits the definitions' do
            validator = validator_class.new
            expect(validator.validate('alpha' => nil)).not_to be_valid
            expect(validator.validate('beta' => nil)).not_to be_valid
            expect(validator.validate('alpha' => nil, 'beta' => nil)).to be_valid
          end

          it "doesn't change the superclass' definition" do
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
