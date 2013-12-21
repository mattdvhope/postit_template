class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :subjects
  has_many :categories, through: :subjects
  has_many :votes, as: :voteable #the foreign key is not 'post_id' on the votes table; instead the foreign key on the 'votes' table is voteable_type/voteable_id (a composite foreign key) #use the ':as' keyword for the 'one' side of the 1:M relationship (in polymorphic associations)

  after_validation :generate_slug #We're using the 'after_validation' (ActiveRecord Callback) method to generate the slug after validation, but before .save ; This implies that our 'generate_slug' method will be executed even for updates; 'before_save' callback method could also work

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  def total_votes #business-logic performed here in the model (for '_post.html.erb')
    self.up_votes - self.down_votes # use 'self.' to be more explicit here
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug
    self.slug = self.title.gsub(' ', '-').downcase #this is set as a variable, but is not yet saved to the DB. Thus, you'll need '.save' in the next line; but better yet, you can save it to the ActiveRecord call-back.
  end

  def to_param # This overwrites the 'to_param' method (That is called by default in the views with something like: 'edit_post_path(@post)').  It is overridden so that the slug can be executed.
    self.slug
  end

end


