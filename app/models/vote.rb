class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true #this tells rails which columns (2 columns) to look for (voteable_type & voteable_id); we have 'voteable' getter & setter methods
          # We don't have specify the parent of this vote because it is polymorphic (i.e., we don't have to say, 'belongs_to :post', etc...).

# validates_uniqueness_of :creator  #This is saying, 'one user can vote only one time' regardless of what vote or what comment--not good; we need scoping!
  validates_uniqueness_of :creator, scope: [:voteable_id, :voteable_type]  #This limits the :creator to one vote per 'post' or 'comment', but he still is allowed to vote on multiple posts & comments.
# validates_uniqueness_of :creator, scope: :voteable  # This means the same thing as line 7.
end