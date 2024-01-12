class ArticlesController < ApplicationController

  def index
    @query = params.fetch(:query, "")
    if !@query.present?
      @articles = Article.all.limit(20)
    else
      @articles = Article.search(@query)
      SearchQuery.create_or_update_recent_similar_query(query: @query)
    end
  end


end
