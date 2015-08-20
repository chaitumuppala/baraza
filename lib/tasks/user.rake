namespace :db do
  desc "Create user"
  task :user => :environment do
    user = User.where(email: 'kumar.vastav@gmail.com')
    if user.blank?
      User.create(first_name: "Kumar", last_name: "baraza",
                         email: 'kumar.vastav@gmail.com', password: "Tester.123", reset_password_token: nil, reset_password_sent_at: nil,
                         confirmed_at: Time.now)
    end
    p "Created user with email: kumar.vastav@gmail.com n password: Tester.123!"
  end

  desc "Create user1"
  task :user => :environment do
    user = User.where(email: 'test.vastav@gmail.com')
    if user.blank?
      User.create(first_name: "Kumar", last_name: "baraza",
                         email: 'test.vastav@gmail.com', password: "Tester.123", reset_password_token: nil, reset_password_sent_at: nil,
                         confirmed_at: Time.now)
    end
    p "Created user with email: test.vastav@gmail.com n password: Tester.123!"
  end
end