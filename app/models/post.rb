class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :subjects
  has_many :categories, through: :subjects
  has_many :votes, as: :voteable #use the ':as' keyword as on the 'one' side of the 1:M relationship (in polymorphic associations)

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true
end


