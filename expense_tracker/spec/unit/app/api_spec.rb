#---
# Excerpted from "Effective Testing with RSpec 3",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rspec3 for more book information.
#---
require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    def parse_response(body)
      JSON.parse(body)
    end

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        expense = { 'some' => 'data' }

        before do
          allow(ledger).to receive(:record)
                               .with(expense)
                               .and_return(RecordResult.new(true, 417, nil))
        end


        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)

          parsed = parse_response(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { {'some' => 'data'} }

        before do
          allow(ledger).to receive(:record)
                               .with(expense)
                               .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end
        # ... specs go here ...
        it 'returns an error message' do
          post '/expenses',JSON.generate(expense)

          parsed=parse_response(last_response.body)
          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses',JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET/expenses/:date' do #
      context 'when expenses exist on the given date' do #
        let(:date) { '2017-06-12' }
        let(:expenses) { [{ 'date' => '2017-06-12' }, { 'date' => '2017-06-12' }] }

        before do
          allow(ledger).to receive(:expenses_on)
                               .with(date)
                               .and_return(ExpensesResult.new(true, expenses, nil))
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2017-06-12'

          parsed = parse_response(last_response.body)
          expect(parsed).to include({ 'date' => '2017-06-12' }, { 'date' => '2017-06-12' })
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2017-06-12'

          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do #
        it 'returns an empty array as JSON'
        it 'responds with a 200 (OK)'
      end
    end
  end
end
