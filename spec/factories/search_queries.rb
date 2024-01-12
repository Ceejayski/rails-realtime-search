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
FactoryBot.define do
  factory :search_query do
    text { Faker::Lorem.paragraph_by_chars(number: 40) }
    user_ip { Faker::Internet.ip_v4_address }
  end
end
