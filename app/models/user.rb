# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  uid                    :string(255)
#  provider               :string(255)
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  year_of_birth          :integer
#  country                :string(255)
#  gender                 :string(255)
#  type                   :string(255)
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  PASSWORD_SUBSTRING = '1Aa!'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  validates :password, format: { with: /(?=.*[a-zA-Z])(?=.*[0-9])(?=.*\W)/ }, if: :password_required?
  validates :first_name, :last_name, presence: true
  alias_attribute :role, :type
  delegate :administrator?, :editor?, :registered_user?, to: :user_role_is
  before_create -> { self.type = RegisteredUser.name if type.blank? }

  has_many :article_owners, as: :owner
  has_many :articles, through: :article_owners
  has_many :proxy_articles, class_name: Article.name, foreign_key: :creator_id

  module Roles
    extend ListValues
    ADMINISTRATOR = 'Administrator'
    EDITOR = 'Editor'
    REGISTERED_USER = 'RegisteredUser'
  end

  module GenderCategory
    extend ListValues
    M = 'M'
    F = 'F'
    OTHER = 'Other'
  end

  def role_symbols
    [role.underscore.to_sym]
  end

  def email_required?
    super && !has_a_provider?
  end

  def password_required?
    super && !has_a_provider?
  end

  def user_role_is
    ActiveSupport::StringInquirer.new(role.underscore)
  end

  def generate_set_password_token
    set_reset_password_token
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_a_provider?
    uid.present? && provider.present?
  end
end
