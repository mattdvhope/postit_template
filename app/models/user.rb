class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true #, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3} # This validation ('on: :create') should only fire up when creating a new user, not when you're updating the user's info; you don't want to have to change your password every time you do a user-update.

  before_save :generate_slug
  
  def admin? # use these two question-mark methods to perform checks in the application
  # self.role == 'admin' #the 'role' method comes from the migration ('role' is now a column in the 'users' table).
    self.role.to_s.to_sym == :admin  #the code above works fine, but the code in this line performs slightly faster.
  end

  def moderator?
    self.role == 'moderator'
  end

  def generate_slug #.slug method comes from the 'slug' column(virtual attribute) in the 'posts' table.
    the_slug = to_slug(self.username)
    user = User.find_by slug: the_slug
    count = 2
    while user && user != self
      the_slug = append_suffix(the_slug, count) #the_slug + "-" + count.to_s
      user = User.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug.downcase #this is set as a variable, but is not yet saved to the DB. Thus, you'll need '.save' in the next line; but better yet, you can save it to the ActiveRecord call-back.
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      return str.split('-').slice(0...-1).join('-') + "-" + count.to_s
    else
      return str + "-" + count.to_s
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
    str.gsub! /-+/, "-"
    str.downcase
  end

  def to_param
    self.slug
  end

end
