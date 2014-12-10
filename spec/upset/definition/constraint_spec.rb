# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe EvaluatedConstraint do
      let :constraint do
        described_class.new(nil)
      end

      describe '#evaluate' do
        it 'raises AlreadyEvaluatedError' do
          expect { constraint.evaluate(nil) }.to raise_error(AlreadyEvaluatedError)
        end
      end

      describe '#satisfied?' do
        it 'returns true if reason is nil' do
          expect(constraint).to be_satisfied
        end

        it 'returns false if reason is not nil' do
          constraint = described_class.new('not nil')
          expect(constraint).not_to be_satisfied
        end
      end
    end

    describe Constraint do
      let :constraint do
        described_class.new
      end

      describe '#evaluate' do
        it 'returns an unsatisfied constraint' do
          expect(constraint.evaluate(nil)).not_to be_satisfied
        end

        it 'explains that constraints must have relations' do
          expect(constraint.evaluate(nil).reason).to match(/without a relation/)
        end
      end
    end
  end
end
