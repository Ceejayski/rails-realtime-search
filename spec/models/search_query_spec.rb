# == Schema Information
#
# Table name: search_queries
#
#  id         :bigint           not null, primary key
#  text       :string
#  user_ip    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_search_queries_on_user_ip  (user_ip)
#
require 'rails_helper'

RSpec.describe SearchQuery, type: :model do
  # Test for validations
  describe 'validations' do
    it { should validate_presence_of(:text) }
    it { should validate_length_of(:text).is_at_least(2) }
    it { should validate_presence_of(:user_ip) }
  end

  # Test for scopes
  describe 'scopes' do
    let!(:search_query1) { create(:search_query, user_ip: '192.168.1.1') }
    let!(:search_query2) { create(:search_query, user_ip: '192.168.1.2') }

    it 'returns search queries by ip' do
      expect(SearchQuery.by_ip('192.168.1.1')).to eq([search_query1])
    end
  end

  # Test for methods
  describe 'methods' do
    before(:each) do
      Current.ip_address = Faker::Internet.ip_v4_address
    end
    let!(:search_query) { create(:search_query, text: 'old query', user_ip: Current.ip_address) }

    describe '.create_or_update_recent_similar_query' do
      context 'when a similar recent query exists' do
        it 'updates the recent query' do
          allow(SearchQuery).to receive(:current_user_query_history).and_return([search_query])

          SearchQuery.create_or_update_recent_similar_query(query: 'old query edited')

          expect(search_query.reload.text).to eq('old query edited')
        end
      end

      context 'when a similar recent query does not exist' do
        it 'creates a new query' do
          allow(SearchQuery).to receive(:current_user_query_history).and_return([search_query])

          expect {
            SearchQuery.create_or_update_recent_similar_query(query: 'new query')
          }.to change(SearchQuery, :count).by(1)
        end
      end

      context 'when no similar recent query exists' do
        it 'creates a new query' do
          allow(SearchQuery).to receive(:current_user_query_history).and_return([])
          allow(SearchQuery).to receive(:similiar_recent_query?).and_return(false)

          expect {
            SearchQuery.create_or_update_recent_similar_query(query: 'new query')
          }.to change(SearchQuery, :count).by(1)
        end
      end
    end

    describe '.similiar_recent_query?' do
      it 'returns true if a similar recent query exists' do
        allow(SearchQuery).to receive(:current_user_query_history).and_return([search_query])

        expect(SearchQuery.similiar_recent_query?('old query edited')).to be_truthy
      end

      it 'returns false if no similar recent query exists' do
        allow(SearchQuery).to receive(:current_user_query_history).and_return([])

        expect(SearchQuery.similiar_recent_query?('new query')).to be_falsey
      end
    end
  end
end
