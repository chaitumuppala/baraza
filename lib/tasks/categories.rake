namespace :db do
  desc "Create categories"
  task :category => :environment do
    category_names = ["Arts and culture", "Climate change", "Global", "Imperialism", "Media", "Movements",
                      "Natural resource exploitation", "Pan-African struggles", "Political economy", "Rights discourse",
                      "Sexuality", "Sovereignty", "Women's Emancipation"]
    category_names.each do |name|
      Category.find_or_create_by(name: name)
    end
  end
end