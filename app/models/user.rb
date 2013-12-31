class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true #, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3} # This validation ('on: :create') should only fire up when creating a new user, not when you're updating the user's info; you don't want to have to change your password every time you do a user-update.

  before_save :generate_slug!
  before_save :capitalize_username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6)) #this generates a random 6-digit number into the 'pin' column of the 'users' table; the 'update_column' method (new to rails 4) automatically hits the db
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    # Get your Account Sid and Auth Token from twilio.com/user/account
    account_sid = 'ACcc04b4439d3b31e9acf51db57f1458da'
    auth_token = '3ba7214d7607d97617958bd4c71f9e19'

    # set up a client to talk to the Twilio REST API
    client = Twilio::REST::Client.new(account_sid, auth_token)
    
    msg = "Hi, please input the PIN to continue login: #{self.pin}"
    message = client.account.sms.messages.create(:body => msg,
    :to => "+17176933230", # Replace with your phone number
    :from => "+17174964038") # Replace with your Twilio number
  end

  def admin? # use these two question-mark methods to perform checks in the application
  # self.role == 'admin' #the 'role' method comes from the migration ('role' is now a column in the 'users' table).
    self.role.to_s.to_sym == :admin  #the code above works fine, but the code in this line performs slightly faster.
  end

  def moderator?
    self.role == 'moderator'
  end

  def capitalize_username
    self.username = self.username.capitalize
  end

  def generate_slug! #.slug method comes from the 'slug' column(virtual attribute) in the 'posts' table.
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
    name.strip.downcase.gsub(/\s*[^a-z0-9]\s*/, '-').gsub /-+/, "-"
  end

  def to_param
    self.slug
  end

end
