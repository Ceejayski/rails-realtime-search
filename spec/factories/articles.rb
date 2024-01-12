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
FactoryBot.define do
  factory :article do
    title { Faker::Lorem.paragraph_by_chars(number: 10) }
    body { Faker::Lorem.paragraph_by_chars(number: 300) }
  end
end
