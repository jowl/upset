# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe Dsl do
      let :validator do
        Class.new.include(described_class).class_exec do
          schema do
            required_property('alpha')
            optional_property('beta').is kind(String)
            optional_property('gamma').is matching(/[A-Z]+/)
            optional_property('delta').are all kind(Integer)
            optional_property('epsilon').is either kind(NilClass), kind(String)
            optional_property('zeta').is both matching(/^A/), matching(/Z$/)
            optional_property('eta') do
              required_property('theta')
            end
          end
        end.new
      end

      describe '#schema' do
        describe '#required_property' do
          it 'adds a required property' do
            expect(validator.validate('alpha' => nil)).to be_valid
            expect(validator.validate({})).not_to be_valid
          end
        end

        describe '#optional_property' do
          let :properties do
            { 'alpha' => nil }
          end

          it 'adds an optional property' do
            expect(validator.validate(properties)).to be_valid
            expect(validator.validate(properties.merge('beta' => 'B'))).to be_valid
          end
        end

        context 'when creating constraints' do
          let :properties do
            { 'alpha' => nil }
          end

          it 'can create KindConstraint' do
            expect(validator.validate(properties.merge('beta' => 'B'))).to be_valid
            expect(validator.validate(properties.merge('beta' => nil))).not_to be_valid
          end

          it 'can create RegexpConstraint' do
            expect(validator.validate(properties.merge('gamma' => 'ABC'))).to be_valid
            expect(validator.validate(properties.merge('gamma' => 'abc'))).not_to be_valid
          end

          it 'can create MemberConstraint' do
            expect(validator.validate(properties.merge('delta' => [1, 2, 3]))).to be_valid
            expect(validator.validate(properties.merge('delta' => [1, nil, 3]))).not_to be_valid
          end

          it 'can create DisjunctiveConstraint' do
            expect(validator.validate(properties.merge('epsilon' => nil))).to be_valid
            expect(validator.validate(properties.merge('epsilon' => 'E'))).to be_valid
            expect(validator.validate(properties.merge('epsilon' => 1))).not_to be_valid
          end

          it 'can create ConjunctiveConstraint' do
            expect(validator.validate(properties.merge('zeta' => 'A-Z'))).to be_valid
            expect(validator.validate(properties.merge('zeta' => 'B-Y'))).not_to be_valid
          end
        end

        context 'when nesting schemas' do
          let :properties do
            { 'alpha' => nil }
          end

          it 'adds definitions for nested properties' do
            expect(validator.validate(properties.merge('eta' => { }))).not_to be_valid
            expect(validator.validate(properties.merge('eta' => { 'theta' => nil }))).to be_valid
          end
        end
      end
    end
  end
end
