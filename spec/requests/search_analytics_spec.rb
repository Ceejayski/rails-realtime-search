require 'rails_helper'

RSpec.describe "SearchAnalytics", type: :request do
  describe "GET /index" do

    context 'when search queries are present' do
      it 'returns the search queries ordered by updated_at in descending order' do
        search_queries = create_list(:search_query, 5, user_ip: '192.168.1.1')
        allow(Current).to receive(:ip_address).and_return('192.168.1.1')
        get search_analytics_path
        expect(response.body).to include(search_queries.first.text)
      end
    end
  end
end
