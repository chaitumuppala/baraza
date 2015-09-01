namespace :db do
  desc 'Create admin'
  task admin: :environment do
    create_user(Administrator, 'admin@example.com', 'Password1!', first_name: 'Admin')
  end

  desc 'Create user'
  task user: :environment do
    create_user(User, 'kumar.vastav@gmail.com', 'Tester.123')
    create_user(User, 'test.vastav@gmail.com', 'Tester.123', first_name: 'Test')
  end

  private

  def create_user(klazz, email, password, options = {})
    user = klazz.find_or_initialize_by(email: email)
    user.update_attributes!({ first_name: 'Kumar', last_name: 'baraza',
                              password: password, reset_password_token: nil, reset_password_sent_at: nil,
                              confirmed_at: Time.current }.merge(options))

    p "Created user with email: #{user.email} and password: #{user.password}!"
  end
end
