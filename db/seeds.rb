# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
(1..10).each do

  # create person
  person = Person.create({
                             first_name: Faker::Name.name,
                             last_name:  Faker::Name.first_name,
                             age:        Random.rand(1..100),
                             city:       Faker::Address.city
                         })

  articles = (1..10).map do
    Article.create({
                     title:        Faker::Name.title,
                     description: Faker::Hacker.say_something_smart,
                     content: Faker::Lorem.sentence(6)
                 })
  end

  person.articles = articles
  person.save
  end