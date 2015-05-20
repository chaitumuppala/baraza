class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  validates :password, format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/ }, if: :password_required?
  validates_presence_of :first_name, :last_name

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

  def send_editor_intro_mail
    EditorWelcomeNotifier.welcome(self).deliver_now
  end
end

