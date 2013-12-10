class Category < ActiveRecord::Base
  has_many :subjects
  has_many :posts, through: :subjects
end
