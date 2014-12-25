# encoding: utf-8

require 'spec_helper'

module Upset
  module Transformation
    {
      IntegerParser => { '12' => 12 },
      FloatParser => { '1.2' => 1.2 },
      BooleanParser => {
        'true' => true,
        'TRUE' => true,
        'false' => false,
        'FALSE' => false
      },
    }.each do |parser_cls, expectations|
      describe parser_cls do
        describe '#call' do
          let :parser do
            described_class.new
          end

          let :parsed_value do
            parser.call(value)
          end

          expectations.each do |string_value, expected_value|
            context "when input is #{string_value.inspect}" do
              let :value do
                string_value
              end

              it "returns #{expected_value.inspect}" do
                expect(parsed_value).to eq(expected_value)
              end
            end
          end

          it 'raises ArgumentError when unable to parse' do
            expect { parser.call('alpha') }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
