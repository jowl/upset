# encoding: utf-8

shared_examples 'a provider' do
  let :properties do
    {
      'alpha' => 1,
      'beta' => 2,
    }
  end

  it 'is a Hash' do
    expect(provider).to be_a(Hash)
  end

  it 'responds to #reload' do
    expect(provider).to respond_to(:reload)
  end

  it 'has the expected properties' do
    expect(provider).to eq(properties)
  end
end
