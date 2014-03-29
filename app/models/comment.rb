class Comment < ActiveRecord::Base
  include Voteable #mix-in Module in /lib/voteable.rb (total_votes, up_votes, down_votes methods) ; Must first go to config/application.rb and insert: config.autoload_paths += %W(#{config.root}/lib).
  # The Voteable module was first in /lib/voteable.rb, but now it's in an installed gem (gem 'voteable_matt38' -- from https://rubygems.org/gems/voteable_matt38)

  belongs_to :post
  belongs_to :creator, :class_name => "User", :foreign_key => 'user_id'
# has_many :votes, as: :voteable ..has been extracted to lib/voteable.rb

  validates :content, presence: true
  validates :post_id, presence: true

# total_votes method extracted to lib/voteable.rb

end