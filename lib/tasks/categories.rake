namespace :db do
  desc "Create categories"
  task :category => :environment do
    category_names = ["category1", "category2", "category3", "category4", "category5", "category6"]
    category_names.each do |name|
      Category.find_or_create_by(name: name)
    end
  end
end