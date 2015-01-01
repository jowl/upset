# encoding: utf-8

require 'spec_helper'

module Upset
  module Definition
    describe SchemaProperty do
      let :schema do
        double(:schema, validate: nil)
      end

      let :schema_property do
        described_class.new(schema, false)
      end

      describe '#validate' do
        it 'validates a Hash configuration using the schema' do
          schema_property.validate({})
          expect(schema).to have_received(:validate).with({})
        end

        it 'validates a Configuration using the schema' do
          configuration = Configuration.new
          schema_property.validate(configuration)
          expect(schema).to have_received(:validate).with(configuration)
        end

        context 'when the configuration is neither a Hash nor a Configuration' do
          it 'returns an invalid ValidationResult' do
            expect(schema_property.validate('string')).not_to be_valid
          end
        end
      end
    end
  end
end
