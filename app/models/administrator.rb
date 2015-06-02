class Administrator < User
  before_validation ->{ self.password = User::PASSWORD_SUBSTRING + SecureRandom.hex[0..5] }, on: :create
  before_create ->{ self.confirmed_at = Time.now}
  after_create :send_admin_intro_mail

  def send_admin_intro_mail
    AdminWelcomeNotifier.welcome(self).deliver_now
  end
end