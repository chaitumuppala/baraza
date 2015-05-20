class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  after_create :send_welcome_mail

  private
  def send_welcome_mail
    AdminWelcomeNotifier.welcome(self).deliver_now
  end
end
