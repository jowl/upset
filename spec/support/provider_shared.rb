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
      expect(provider[property]).to eq(value)
    end
  end
end
