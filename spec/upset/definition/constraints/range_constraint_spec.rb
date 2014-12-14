# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe RangeConstraint do
      describe '#evaluate' do
        let :constraint do
          described_class.new(1, 3)
        end

        context 'when value is within the bounds' do
          it 'returns a satisfied constraint' do
            (1..3).each do |value|
              expect(constraint.evaluate(value)).to be_satisfied
            end
          end
        end

        context 'when value is greater than the upper bound' do
          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(4)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(4).reason).to match(/expected 4 to be between 1 and 3/i)
          end
        end

        context 'when value is less than the lower bound' do
          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(0)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(0).reason).to match(/expected 0 to be between 1 and 3/i)
          end
        end

        context 'when value is not a Comparable' do
          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate([])).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate([]).reason).to match(/expected.+comparable.+got.+array/i)
          end
        end
      end

      context 'without upper bound' do
        let :constraint do
          described_class.new(1, nil)
        end

        describe '#evaluate' do
          context 'when value is greater than the lower bound' do
            it 'returns a satisfied constraint' do
              expect(constraint.evaluate(1)).to be_satisfied
            end
          end

          context 'when value is less than the lower bound' do
            it 'returns an unsatisfied constraint' do
              expect(constraint.evaluate(0)).not_to be_satisfied
            end

            it 'returns an unsatisfied constraint with a sensible reason' do
              expect(constraint.evaluate(0).reason).to match(/expected 0 to be greater than 1/i)
            end
          end
        end
      end

      context 'without lower bound' do
        let :constraint do
          described_class.new(nil, 3)
        end

        describe '#evaluate' do
          context 'when value is less than the upper bound' do
            it 'returns a satisfied constraint' do
              expect(constraint.evaluate(3)).to be_satisfied
            end
          end

          context 'when value is greater than the upper bound' do
            it 'returns an unsatisfied constraint' do
              expect(constraint.evaluate(4)).not_to be_satisfied
            end

            it 'returns an unsatisfied constraint with a sensible reason' do
              expect(constraint.evaluate(4).reason).to match(/expected 4 to be less than 3/i)
            end
          end
        end
      end
    end
  end
end
