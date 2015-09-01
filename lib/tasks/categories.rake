namespace :db do
  desc 'Create categories'
  task category: :environment do
    category_names = ['Features', 'Commentaries', 'Urgent actions', 'Campaigns', 'Reviews', 'Audio-visuals', 'Courses', 'Events', 'Announcements', 'Jobs']
    category_names.each do |name|
      Category.find_or_create_by(name: name)
    end
  end
end
