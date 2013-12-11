class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :subjects
  has_many :categories, through: :subjects

  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
end


