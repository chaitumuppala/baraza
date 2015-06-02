namespace :db do
  desc "Create admin"
  task :admin => :environment do
    user = User.where(email: 'admin@example.com')
    if user.blank?
      user = Administrator.create(first_name: "Admin", last_name: "baraza",
                         email: 'admin@example.com')
      user.update_attributes( password: "Password1!", reset_password_token: nil, reset_password_sent_at: nil )
    end
    p "Created admin with email: admin@example.com n password: Password1!"
  end
end