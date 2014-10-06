# encoding: utf-8

require 'spec_helper'

module Upset
  class Definition
    describe RegexpConstraint do
      let :constraint do
        described_class.new(pattern)
      end

      let :pattern do
        /^alpha$/
      end

      let :value do
        'alpha'
      end

      describe '#evaluate' do
        context 'when value matches pattern' do
          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end

        context "when value doesn't match pattern" do
          let :pattern do
            /^beta$/
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(value).reason).to match(/expected.+alpha.+to match.+\^beta\$/i)
          end
        end

        context "when value isn't a String" do
          let :value do
            {}
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(value).reason).to match(/expected.+{}.+to match.+\^alpha\$/i)
          end
        end
      end
    end
  end
end
