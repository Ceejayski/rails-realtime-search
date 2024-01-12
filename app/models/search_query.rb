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

require 'jaro_winkler'

class SearchQuery < ApplicationRecord
  #  Associations

  #  Validations
  validates :text, presence: true, length: { minimum: 2 }
  validates :user_ip, presence: true
  # Scopes
  scope :by_ip, ->(ip) { where(user_ip: ip) }

  #  Methods

  # Create or update similar recent query
  def self.create_or_update_recent_similar_query(query: "")
    sanitized_query = sanitize_sql_like(query)
    if similiar_recent_query?(sanitized_query)
      recent_search_query = current_user_query_history.last
      recent_search_query.update(text: sanitized_query) if recent_search_query.text.length < sanitized_query.length
    else
      SearchQuery.create(text: sanitized_query, user_ip: Current.ip_address)
    end
  end

  def self.current_user_query_history
    SearchQuery.order(:updated_at)
               .by_ip(Current.ip_address)
  end

  private
    # Check if query is similar to recent query
    def self.similiar_recent_query?(text)
      recent_search_query = current_user_query_history.last
      recent_search_query.present? && JaroWinkler.similarity_distance(text, recent_search_query.text) > 0.75
    end
end
