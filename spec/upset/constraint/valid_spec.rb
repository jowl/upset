# encoding: utf-8

require 'spec_helper'

module Upset
  class Constraint
    describe Valid do
      let :constraint do
        described_class.new
      end

      describe '#evaluate' do
        it 'is always satisfied' do
          [nil, 1, [], {}, ''].map do |value|
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end
      end
    end
  end
end
