class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3} # This validation ('on: :create') should only fire up when creating a new user, not when you're updating the user's info; you don't want to have to change your password every time you do a user-update.

end
