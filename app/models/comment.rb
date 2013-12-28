class Comment < ActiveRecord::Base
  # include Voteable #mix-in Module in /lib/voteable.rb (total_votes, up_votes, down_votes methods)
  include VoteableMattDec #include this module from: gem 'voteable_matt_dec'

  belongs_to :post
  belongs_to :creator, :class_name => "User", :foreign_key => 'user_id'
# has_many :votes, as: :voteable ..has been extracted to lib/voteable.rb

  validates :content, presence: true
  validates :post_id, presence: true

end