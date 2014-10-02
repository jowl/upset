# encoding: utf-8

require 'spec_helper'

module Upset
  module Constraint
    describe ValidConstraint do
      let :constraint do
        described_class.new
      end

      describe '#evaluate' do
        it 'returns a satisfied Result for any value' do
          results = [nil, 1, [], {}, ''].map do |value|
            constraint.evaluate(value)
          end
          expect(results).to all be_satisfied
        end
      end
    end
  end
end
