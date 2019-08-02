# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

a = ParseDate.new('https://1000mostcommonwords.com/1000-most-common-italian-words', '//* [@id="post-55"]/div/table/tbody/tr[position() > 1]/td[position() > 1]')

a.parsing
