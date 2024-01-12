require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "GET /index" do
    context 'when no query is provided' do
      it 'returns all articles' do
        articles = create_list(:article, 10)
        get articles_path
        articles.each do |article|
          expect(response.body).to include(article.title)
        end
      end
    end

    context 'when a query is provided' do
      it 'returns the articles matching the query' do
        article = create(:article, title: 'Test Article')
        get articles_path, params: { query: 'Test' }
        expect(response.body).to include('Test Article')
      end
    end

  end
end
