module Voteable
  extend ActiveSupport::Concern #this is something new for Rails 4; this abstracts away a common pattern for meta-programming; it means that all the instance methods written here are going to be instance methods when I include/mix-in this Module
                                #this is not pure ruby in this file; ActiveSupport is a gem that is a somewhat related to Rails
                                #class methods can be included here too, in addition to the instance methods above
                                #when we mix in the Module, the class methods will automatically be added as class methods

  included do #It says, "When the module is being included, execute this code."  This code is only included once. In this case this formerly redundant code has been extracted from the 'post.rb' & 'comment.rb' models.
    has_many :votes, as: :voteable #the foreign key is not 'post_id' on the votes table; instead the foreign key on the 'votes' table is voteable_type/voteable_id (a composite foreign key) #use the ':as' keyword for the 'one' side of the 1:M relationship (in polymorphic associations)
  end

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