# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# 1.times do |i|
#   print "\rSeeding customers (%d)... %0.2f%%" % [i, i / 1_000_000.0 * 100] if i % 100 == 0
# 
#   Customer.create! first_name: Faker::Name.first_name,
#                    last_name: Faker::Name.last_name,
#                    username: "#{Faker::Internet.user_name}#{i}",
#                    email: "#{Faker::Internet.user_name}#{i}@#{Faker::Internet.domain_name}"
# end
# puts "\nDone."

def seed(message, &block)
  print "\r  - #{message}..."
  block.call
  print "done.\n"
end

def admins
  seed "admins" do
    begin
      user = User.create first_name: "Baraza", last_name: "Administrator", email: "admin@panafricanbaraza.org", type: "Administrator", password: "it-ek-is-fef", password_confirmation: "it-ek-is-fef"
      user.confirm! if user
    rescue ActiveRecord::RecordNotUnique
    end
  end
end

def categories
  categories = ['Features', 'Commentaries', 'Urgent actions', 'Campaigns', 'Reviews', 'Audio-visuals', 'Courses', 'Events', 'Announcements', 'Jobs']

  seed "categories" do
    categories.each { |category| Category.find_or_create_by! name: category }
  end
end

def subscribers
  seed "subscribers" do
    Subscriber.find_or_create_by! email: "hanselmahlaola@gmail.com"
  end
end

puts "Seeding Baraza..."
admins
categories
subscribers
