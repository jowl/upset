# encoding: utf-8

require 'spec_helper'
require 'tempfile'
require 'tmpdir'

module Upset
  module Definition
    describe FileConstraint do
      let :constraint do
        described_class.new
      end

      describe '#evaluate' do
        context 'when value is a path to an existing file' do
          let :file do
            Tempfile.new('some-file')
          end

          after do
            file.close
            file.unlink
          end

          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(file.path)).to be_satisfied
          end
        end

        context 'when value is a path to an existing directory' do
          let :directory do
            Dir.mktmpdir('some-dir')
          end

          after do
            FileUtils.remove_entry_secure(directory)
          end

          it 'returns a satisfied constraint' do
            expect(constraint.evaluate(directory)).to be_satisfied
          end
        end

        context 'when value is a path to a non-existing file' do
          let :value do
            '/path/to/a/non-existing/file'
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(value).reason).to match(/non-existing\/file does not exist/i)
          end
        end

        context "when value isn't a String" do
          let :value do
            []
          end

          it 'returns an unsatisfied constraint' do
            expect(constraint.evaluate(value)).not_to be_satisfied
          end

          it 'returns an unsatisfied constraint with a sensible reason' do
            expect(constraint.evaluate(value).reason).to match(/expected.+string.+got.+array/i)
          end
        end
      end
    end
  end
end
