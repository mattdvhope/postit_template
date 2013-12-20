class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :creator, :class_name => "User", :foreign_key => 'user_id'
  has_many :votes, as: :voteable #the foreign key is not 'comment_id' on the votes table; instead the foreign key on the 'votes' table is voteable_type/voteable_id (a composite foreign key) #use the ':as' keyword for the 'one' side of the 1:M relationship (in polymorphic associations)

  validates :content, presence: true
  validates :post_id, presence: true

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