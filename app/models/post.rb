class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :subjects
  has_many :categories, through: :subjects
  has_many :votes, as: :voteable #the foreign key is not 'post_id' on the votes table; instead the foreign key on the 'votes' table is voteable_type/voteable_id (a composite foreign key) #use the ':as' keyword for the 'one' side of the 1:M relationship (in polymorphic associations)

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

end


