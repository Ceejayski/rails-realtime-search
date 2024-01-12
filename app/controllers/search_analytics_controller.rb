class SearchAnalyticsController < ApplicationController
  def index
    @search_queries = SearchQuery.order(updated_at: :desc).by_ip(Current.ip_address)

  end
end
