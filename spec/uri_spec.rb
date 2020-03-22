require 'uri'

RSpec.describe URI do
  it_behaves_like 'URL parser', URI

  it 'defaults the port for an http URI to 80' do
    expect(URI.parse('http://example.com/').port).to eq 80
  end

  it 'defaults the port for an https URI to 443' do
    expect(URI.parse('https://example.com/').port).to eq 443
  end
end