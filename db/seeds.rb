# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# seed the database with users who can access the admin page
[
  { email: 'rob@notch8.com', password: 'testing123'},
  { email: 'support@notch8.com', password: 'testing123'},
  { email: 'admin@example.com', password: 'testing123'},
  { email: 'user@notch8.com', password: 'testing123'},
  { email: 'user@example.com', password: 'testing123'}
].each do |set|
  next if User.find_by(email: set[:email])
  user = User.create!(email: set[:email], password: set[:password])
end