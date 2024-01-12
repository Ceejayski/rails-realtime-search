# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ApplicationRecord
  # Validation
  validates :title, presence: true, length: { minimum: 5, maximum: 30 }
  validates :body, presence: true, length: { minimum: 10, maximum: 300 }
  #scopes
  scope :search, ->(query) { where('lower(title) LIKE :sanitized_query or lower(body) LIKE :sanitized_query', sanitized_query: "%#{sanitize_sql_like(query.downcase)}%") }
end
