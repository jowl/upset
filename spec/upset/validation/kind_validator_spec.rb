# encoding: utf-8

require 'spec_helper'

module Upset
  module Validation
    describe KindValidator do
      let :validator do
        described_class.new(kind)
      end

      let :value do
        []
      end

      describe '#validate' do
        context 'when value is an instance of the given class' do
          let :kind do
            Array
          end

          it 'returns a valid Result' do
            expect(validator.validate(value)).to be_valid
          end
        end

        context 'when value is an instance of a subclass of the given class' do
          let :kind do
            Object
          end

          it 'returns a valid Result' do
            expect(validator.validate(value)).to be_valid
          end
        end

        context 'when value is an instance of a class that includes the given class' do
          let :kind do
            Enumerable
          end

          it 'returns a valid Result' do
            expect(validator.validate(value)).to be_valid
          end
        end

        context 'when value is an instance of another class' do
          let :kind do
            Fixnum
          end

          it 'returns an invalid Result' do
            expect(validator.validate(value)).not_to be_valid
          end

          it 'returns an invalid Result with a sensible reason' do
            expect(validator.validate(value).reason).to match(/expected.+fixnum.+got.+array/i)
          end
        end
      end
    end
  end
end
