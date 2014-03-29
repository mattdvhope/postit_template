class Post < ActiveRecord::Base
  include Voteable #mix-in Module in /lib/voteable.rb (total_votes, up_votes, down_votes methods) ; Must first go to config/application.rb and insert: config.autoload_paths += %W(#{config.root}/lib).
  # The Voteable module was first in /lib/voteable.rb, but now it's in an installed gem (gem 'voteable_matt38' -- from https://rubygems.org/gems/voteable_matt38)

  include Sluggable #mix-in Module in /lib/sluggable.rb (generate_slug, append_suffix, to_slug, to_param) ; Already went to config/application.rb and inserted: config.autoload_paths += %W(#{config.root}/lib).

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :subjects
  has_many :categories, through: :subjects
# has_many :votes, as: :voteable ..has been extracted to lib/voteable.rb

# before_save extracted to lib/sluggable.rb
# before_save :generate_slug! # We could alse use the 'after_validation' (ActiveRecord Callback) method to generate the slug after validation (implying that it happens before_save); This implies that our 'generate_slug' method will be executed even for updates; if we used 'before_create', then this method would only be fired ONCE (upon creation), which is what we DON'T want.  We want to be able to change the title and thus also change the slug. There are times when you'd want to do 'before_create' -- allows you to prevent breaking bookmarks whenever the title is changed.
                              # When building a new app, and you want to do :generate_slug! after you already have a bunch of titles, just go to the rails console and do: Post.all { |post| post.save }.  That will enable you to run the generate_slug! method which definitely occur before each 'save'.
  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  sluggable_column :title # Because the 'posts' table has the 'title' column.  The 'categories' & the 'users' tables have different column names that will be used in 'lib/sluggable.rb'.
# sluggable_column is a method is lib/sluggable.rb

end


