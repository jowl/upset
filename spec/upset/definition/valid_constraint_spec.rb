# encoding: utf-8

require 'spec_helper'

module Upset
  class Definition
    describe ValidConstraint do
      let :constraint do
        described_class.new
      end

      describe '#evaluate' do
        it 'always returns a satisfied constraint' do
          [nil, 1, [], {}, ''].map do |value|
            expect(constraint.evaluate(value)).to be_satisfied
          end
        end
      end
    end
  end
end
