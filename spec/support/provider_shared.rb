# encoding: utf-8

shared_examples 'a provider' do
  let :properties do
    {
      'alpha' => 1,
      'beta' => 2,
    }
  end

  context 'which quacks like a Hash and' do
    it 'responds to #[]' do
      expect(provider).to respond_to(:[])
    end

    it 'responds to #keys' do
      expect(provider).to respond_to(:keys)
    end

    it 'responds to #has_key?' do
      expect(provider).to respond_to(:has_key?)
    end
  end

  it 'has the expected properties' do
    properties.each do |property, value|
      expect(provider[property].value).to eq(value)
    end
  end

  describe '#[]' do
    it 'returns a PropertyValue' do
      expect(provider[properties.keys.first]).to be_a(Upset::Provision::PropertyValue)
    end

    it 'returns nil for non-existing properties' do
      expect(provider['missing-parameter']).to be_nil
    end
  end
end
