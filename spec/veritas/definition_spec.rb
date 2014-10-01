# encoding: utf-8

require 'spec_helper'

module Veritas
  describe Definition do
    let :required do
      %w[alpha]
    end

    let :optional do
      %w[bravo]
    end

    let :definition do
      described_class.new(required, optional)
    end

    let :configuration do
      {
        'alpha' => 1,
        'bravo' => 2,
      }
    end

    describe '#validate' do
      it "doesn't always raise errors" do
        expect { definition.validate(configuration) }.not_to raise_error
      end

      it 'raises MissingParameterError when a required parameter is missing' do
        configuration.delete('alpha')
        expect { definition.validate(configuration) }.to raise_error(MissingParameterError, /missing.+alpha/i)
      end

      it "doesn't raise error when an optional parameter is missing" do
        configuration.delete('bravo')
        expect { definition.validate(configuration) }.not_to raise_error
      end

      it "raises UnknownParameterError when a parameter isn't required nor optional" do
        configuration.merge!('caesar' => 3)
        expect { definition.validate(configuration) }.to raise_error(UnknownParameterError, /unknown.+caesar/i)
      end
    end

    describe '#describe' do
    end
  end
end
