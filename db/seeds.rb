# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
20.times do |n|
  Task.create!(
    title: "sample task#{n + 1}",
    content: "sample content#{n + 1}",
    deadline_on: "2022-05-#{n + 1}",
    priority: rand(3),
    status: rand(3)
  )
end