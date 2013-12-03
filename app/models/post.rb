class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :subjects
  has_many :categories, :through => :subjects
end


