class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true #this tells rails which columns (2 columns, in this case) to look for (voteable_type & voteable_id); we have a 'voteable' getter & setter
end