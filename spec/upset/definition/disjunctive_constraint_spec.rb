# encoding: utf-8

require 'spec_helper'
require 'support/spec_constraints'

module Upset
  class Definition
    describe DisjunctiveConstraint do
      let :constraints do
        [
          SpecConstraints::InvalidConstraint.new,
          ValidConstraint.new,
        ]
      end

      let :constraint do
        described_class.new(*constraints)
      end

      let :value do
        nil
      end

      describe '#evaluate' do
        context 'when any constraint is satisfied' do
          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end

        context 'when all constraints are unsatisfied' do
          let :constraints do
            [SpecConstraints::InvalidConstraint.new] * 3
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it "returns an unsatisfied constraint with all constraints' reasons" do
            expect(constraint.evaluate(value).reason).to match(/(this will always be unsatisfied).+\1.+\1/i)
          end
        end
      end
    end
  end
end
