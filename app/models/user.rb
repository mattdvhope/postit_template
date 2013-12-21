class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3} # This validation ('on: :create') should only fire up when creating a new user, not when you're updating the user's info; you don't want to have to change your password every time you do a user-update.

  def admin? # use these two question-mark methods to perform checks in the application
  # self.role == 'admin' #the 'role' method comes from the migration ('role' is now a column in the 'users' table).
    self.role.to_s.to_sym == :admin  #the code above works fine, but the code in this line performs slightly faster.
  end

  def moderator?
    self.role == 'moderator'
  end

end
