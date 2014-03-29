class User < ActiveRecord::Base
  include Sluggable #mix-in Module in /lib/sluggable.rb (generate_slug, append_suffix, to_slug, to_param) ; Already went to config/application.rb and inserted: config.autoload_paths += %W(#{config.root}/lib).

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3} # This validation ('on: :create') should only fire up when creating a new user, not when you're updating the user's info; you don't want to have to change your password every time you do a user-update.

  before_save :generate_slug!
  before_save :capitalize_username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6)) #this generates a random 6-digit number into the 'pin' column of the 'users' table; the 'update_column' method (new to rails 4) automatically hits the db (performs 'save').
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
    :to => "+17176894933", # Replace with your phone number ; "+17176933230"
    :from => "+17174964038") # Replace with your Twilio number
  end

  def admin? # The admin role can: 1. Can modify any model in the whole application, except for deleting users; a "super-user" can do anything, including deleting users.
  # self.role == 'admin' #the 'role' method/column comes from the new migration ('role' is now a column in the 'users' table).
    self.role.to_s.to_sym == :admin  #the code above works fine, but the code in this line performs slightly faster.
  end

  def moderator?
    self.role == 'moderator' # A moderator can: 1. Create posts; 2. Edit posts; 3. Edit other people's posts; 4. Flag posts & comments.
  end

  def capitalize_username
    self.username = self.username.capitalize
  end

  sluggable_column :username # Because the 'users' table has the 'username' column.  The 'categories' & the 'posts' tables have different column names that will be used in 'lib/sluggable.rb'.
# sluggable_column is a method is lib/sluggable.rb

end
