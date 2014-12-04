# encoding: utf-8

shared_examples 'provider_common' do
  let :property do
    properties.keys.first
  end

  before do
    expect(properties).not_to be_empty
  end

  it 'has the expected properties' do
    properties.each do |property, value|
      expect(provider[property].value).to eq(value)
    end
  end

  describe '#keys' do
    it 'return all property names' do
      expect(provider.keys).to match_array(properties.keys)
    end
  end

  describe '#has_key?' do
    it 'returns true if there is a property with the given name' do
      expect(provider).to have_key(property)
    end

    it 'returns false if there is no property with the given name' do
      expect(provider).not_to have_key('non-existing-property')
    end
  end

  describe '#[]' do
    it 'returns a PropertyValue' do
      expect(provider[property]).to be_a(Upset::PropertyValue)
    end

    it 'returns nil for non-existing properties' do
      expect(provider['missing-parameter']).to be_nil
    end
  end
end
