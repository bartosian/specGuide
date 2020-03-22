RSpec.shared_context 'API helpers' do 
  include Rack::TEST::Methods

  def app
    ExpenseTracker::API.new
  end

  before do
    basic_authorize 'test_user', 'test_password'
  end
end