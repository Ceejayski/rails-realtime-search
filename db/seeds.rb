# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'
if Article.count.zero?
  20.times do
    Article.create(title: Faker::Lorem.paragraph_by_chars(number: 10), body: Faker::Lorem.paragraph_by_chars(number: 300))
  end
end
