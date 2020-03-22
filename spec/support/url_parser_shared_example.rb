RSpec.shared_examples 'URL parser' do |url_parser_class|
  let(:url_parser) { url_parser_class.new }

  it 'parses the host' do
    expect(url_parser.parse('http://foo.com/').host).to eq 'foo.com'
  end

  it 'parses the port' do
    expect(url_parser.parse('http://example.com:9876').port).to eq 9876
  end
end