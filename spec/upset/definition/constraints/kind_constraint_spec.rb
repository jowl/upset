# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe KindConstraint do
      let :constraint do
        described_class.new(kind)
      end

      let :value do
        []
      end

      describe '#evaluate' do
        context 'when value is an instance of the given class' do
          let :kind do
            Array
          end

          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end

        context 'when value is an instance of a subclass of the given class' do
          let :kind do
            Object
          end

          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end

        context 'when value is an instance of a class that includes the given class' do
          let :kind do
            Enumerable
          end

          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end

        context 'when value is an instance of another class' do
          let :kind do
            Fixnum
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(value).reason).to match(/expected.+fixnum.+got.+array/i)
          end
        end
      end
    end
  end
end
