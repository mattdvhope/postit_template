class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :creator, :class_name => "User", :foreign_key => 'user_id'
  has_many :votes, as: :voteable #use the ':as' keyword as on the 'one' side of the 1:M relationship (in polymorphic associations)
                                 #'votes' is polymorphic so we don't have to create a new foreign key
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