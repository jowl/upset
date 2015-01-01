# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe ValidationResult do
      describe '#trace' do
        it 'is empty for the root cause' do
          expect(described_class.new('message').trace).to be_empty
        end

        it "contains causes' messages" do
          messages = 3.times.map { |i| 'cause %d' % i }
          causes = messages.map { |msg| described_class.new(msg) }
          expect(described_class.new('message', causes).trace).to match_array messages
        end

        context 'when there are nested causes' do
          let :causes do
            [
              described_class.new('cause 0'),
              described_class.new('cause 1', cause_1_causes),
              described_class.new('cause 2'),
            ]
          end

          let :cause_1_causes do
            [
              described_class.new('cause 10'),
              described_class.new('cause 11', cause_11_causes),
              described_class.new('cause 12'),
            ]
          end

          let :cause_11_causes do
            [
              described_class.new('cause 110'),
              described_class.new('cause 111'),
              described_class.new('cause 112'),
            ]
          end

          let :validation_result do
            described_class.new('message', causes)
          end

          it 'indents causes nicely' do
            lines = [
              'cause 0',
              'cause 1',
              '  cause 10',
              '  cause 11',
              '    cause 110',
              '    cause 111',
              '    cause 112',
              '  cause 12',
              'cause 2',
            ]
            expect(validation_result.trace).to eq(lines)
          end
        end
      end
    end
  end
end
