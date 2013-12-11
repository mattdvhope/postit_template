class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :creator, :class_name => "User", :foreign_key => 'user_id'

  validates :content, presence: true
  validates :post_id, presence: true

end