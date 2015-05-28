namespace :db do
  desc "Create admin"
  task :admin => :environment do
    user = User.where(email: 'admin@example.com')
    Administrator.create(first_name: "Admin", last_name: "baraza", password: "Password1!",
                         email: 'admin@example.com', confirmed_at: Time.now) if user.blank?
    p "Created admin with email: admin@example.com n password: Password1!"
  end
end