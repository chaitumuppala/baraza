class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  PASSWORD_SUBSTRING = "1Aa!"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  validates :password, format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/ }, if: :password_required?
  validates_presence_of :first_name, :last_name
  alias_attribute :role, :type
  after_update :send_editor_intro_mail, if: -> { type_changed? && type == Editor.name}

  module Roles
    extend ListValues
    EDITOR = "Editor"
  end

  module GenderCategory
    extend ListValues
    M = "M"
    F = "F"
    OTHER = "Other"
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

  def update_email(new_email)
    return update_attributes(email: new_email) if new_email.present? && User.where(email: new_email).blank?
    false
  end

  private
  def has_a_provider?
    uid.present? && provider.present?
  end

  def send_editor_intro_mail
    EditorWelcomeNotifier.welcome(self).deliver_now
  end
end

