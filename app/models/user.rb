class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  validates :password, format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/ }, if: :password_required?
  validates_presence_of :first_name, :last_name
  def email_required?
    super && !has_a_provider?
  end

  def password_required?
    super && !has_a_provider?
  end

  private
  def has_a_provider?
    uid.present? && provider.present?
  end
end

