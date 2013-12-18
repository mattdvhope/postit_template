class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :creator, :class_name => "User", :foreign_key => 'user_id'
  has_many :votes, as: :voteable #use the ':as' keyword as on the 'one' side of the 1:M relationship (in polymorphic associations)
                                 #'votes' is polymorphic so we don't have to create a new foreign key
  validates :content, presence: true
  validates :post_id, presence: true

end