class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :password, length: 6..10, if: :password_required?
  validates :password, format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W)/ }, if: :password_required?
end
