# encoding: utf-8

require 'spec_helper'

module Upset
  class Definition
    describe MemberConstraint do
      let :member_constraint do
        KindConstraint.new(Fixnum)
      end

      let :constraint do
        described_class.new(member_constraint)
      end

      let :value do
        3.times.to_a
      end

      describe '#evaluate' do
        context 'when the value is empty' do
          it 'returns a satisfied constraint' do
            expect(constraint.evaluate([])).to be_satisfied
          end
        end

        context 'when every member of the enumerable value satisfies the constraint' do
          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end

        context "when the value isn't enumerable" do
          let :value do
            1
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(value).reason).to match(/expected.+enumerable.+got.+fixnum/i)
          end
        end

        context "when any member of the enumerable value doesn't satisfy the constraint" do
          let :value do
            [1, 'a', 2, 'b', 3]
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(value).reason).to match(/(expected.+fixnum.+got.+string).+\1/i)
          end
        end
      end
    end
  end
end
