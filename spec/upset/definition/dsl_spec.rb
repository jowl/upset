# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe Dsl do
      let :config_class do
        Class.new(described_class).tap do |cls|
          cls.class_exec do
            required 'alpha'
            optional 'beta', kind: String
            optional 'gamma', regexp: /[A-Z]+/
            optional 'delta', member: { kind: Integer }
            optional 'epsilon', any: [{kind: NilClass}, {kind: String}]
            optional 'zeta', all: [{regexp: /^A/}, {regexp: /Z$/}]
          end
        end
      end

      describe '#required' do
        it 'adds a required property' do
          expect(config_class.new('alpha' => nil)).to be_valid
          expect(config_class.new({})).not_to be_valid
        end
      end

      describe '#optional' do
        let :properties do
          { 'alpha' => nil }
        end

        it 'adds an optional property' do
          expect(config_class.new(properties)).to be_valid
          expect(config_class.new(properties.merge('beta' => 'B'))).to be_valid
        end
      end

      context 'when creating constraints' do
        let :properties do
          { 'alpha' => nil }
        end

        it 'can create KindConstraint' do
          expect(config_class.new(properties.merge('beta' => 'B'))).to be_valid
          expect(config_class.new(properties.merge('beta' => nil))).not_to be_valid
        end

        it 'can create RegexpConstraint' do
          expect(config_class.new(properties.merge('gamma' => 'ABC'))).to be_valid
          expect(config_class.new(properties.merge('gamma' => 'abc'))).not_to be_valid
        end

        it 'can create MemberConstraint' do
          expect(config_class.new(properties.merge('delta' => [1, 2, 3]))).to be_valid
          expect(config_class.new(properties.merge('delta' => [1, nil, 3]))).not_to be_valid
        end

        it 'can create DisjunctiveConstraint' do
          expect(config_class.new(properties.merge('epsilon' => nil))).to be_valid
          expect(config_class.new(properties.merge('epsilon' => 1))).not_to be_valid
        end

        it 'can create ConjunctiveConstraint' do
          expect(config_class.new(properties.merge('zeta' => 'A-Z'))).to be_valid
          expect(config_class.new(properties.merge('zeta' => 'B-Y'))).not_to be_valid
        end
      end
    end
  end
end
