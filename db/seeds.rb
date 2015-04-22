# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#   10.times do
#
#   # create person
#   person = Person.create({
#                              first_name: Faker::Name.name,
#                              last_name:  Faker::Name.first_name,
#                              age:        Random.rand(1..100),
#                              city:       Faker::Address.city
#                          })
#
#   # articles = (1..10).map do
#   #   Article.create({
#   #                    title:        Faker::Name.title,
#   #                    description: Faker::Hacker.say_something_smart,
#   #                    content: Faker::Lorem.sentence(6)
#   #                })
#   # end
#
#   person.articles = articles
#   person.save
# end

 10.times do
  #Author.create_index! force: true
  author = Author.create({
                             firstname: Faker::Name.name,
                             lastname:  Faker::Name.first_name,
                             age:       Random.rand(1..100)
                         })
  puts author
    b = author.books.create({
                       title:        Faker::Name.title,
                       book_type:    Faker::Lorem.word,
                       fiction:      rand(2) == 1 ? true : false,
                       published_at: Faker::Date.between(1000.days.ago, Date.today),
                       price:        Random.rand(1..1000),
                   })
   10.times do
    b.chapters.create({
                    title:        Faker::Name.title,
                    description:  Faker::Hacker.say_something_smart,
                    content: Faker::Lorem.sentences(6),
                })
  end
  end
#
#
#   author.books = book
#   b = Book.last
#   b.chapters = chapter
#
#   author.save
#   b.save
# end
# 10.times do
#   Book.last.chapters.create({
#                                 title:        Faker::Name.title,
#                                 description:  Faker::Hacker.say_something_smart,
#                                 content: Faker::Lorem.sentences(6),
#                             })
# end
