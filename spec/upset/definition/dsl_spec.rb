# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe Dsl do
      def schema(&block)
        Class.new.include(described_class).class_exec { schema(&block) }.new
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
              optional_property('alpha')
            end
          end

          it 'adds an optional property' do
            expect(validator.validate({})).to be_valid
            expect(validator.validate('alpha' => nil)).to be_valid
          end
        end

        context 'with constraints' do
          describe '#kind' do
            let :validator do
              schema do
                required_property('alpha').is kind(String)
              end
            end

            it 'creates KindConstraint' do
              expect(validator.validate('alpha' => 'A')).to be_valid
              expect(validator.validate('alpha' => nil)).not_to be_valid
            end
          end

          describe '#matching' do
            let :validator do
              schema do
                required_property('alpha').is matching(/[A-Z]+/)
              end
            end

            it 'creates RegexpConstraint' do
              expect(validator.validate('alpha' => 'ABC')).to be_valid
              expect(validator.validate('alpha' => 'abc')).not_to be_valid
            end
          end

          describe '#all' do
            let :validator do
              schema do
                required_property('alpha').are all kind(Integer)
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
                required_property('alpha').is either kind(String), kind(NilClass)
              end
            end

            it 'creates DisjunctiveConstraint' do
              expect(validator.validate('alpha' => nil)).to be_valid
              expect(validator.validate('alpha' => 'A')).to be_valid
              expect(validator.validate('alpha' => 1)).not_to be_valid
            end
          end

          describe '#either' do
            let :validator do
              schema do
                required_property('alpha').is both matching(/^A/), matching(/Z$/)
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
              optional_property('alpha') do
                required_property('beta')
              end
            end
          end

          it 'adds definitions for nested properties' do
            expect(validator.validate('alpha' => { })).not_to be_valid
            expect(validator.validate('alpha' => { 'beta' => nil })).to be_valid
          end
        end
      end
    end
  end
end
