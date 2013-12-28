class Post < ActiveRecord::Base
  # include Voteable #mix-in Module in /lib/voteable.rb (total_votes, up_votes, down_votes methods)
  include VoteableMattDec #include this module from: gem 'voteable_matt_dec'

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :subjects
  has_many :categories, through: :subjects
# has_many :votes, as: :voteable ..has been extracted to lib/voteable.rb

  before_save :generate_slug #We're using the 'after_validation' (ActiveRecord Callback) method to generate the slug after validation, but before .save ; This implies that our 'generate_slug' method will be executed even for updates; 'after_validation' callback method might(?) also work

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  def generate_slug #.slug method comes from the 'slug' column(virtual attribute) in the 'posts' table.
    the_slug = to_slug(self.title)
    post = Post.find_by slug: the_slug
    count = 2
    while post && post != self
      the_slug = append_suffix(the_slug, count) #the_slug + "-" + count.to_s
      post = Post.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug.downcase #this is set as a variable, but is not yet saved to the DB. Thus, you'll need '.save' in the next line; but better yet, you can save it to the ActiveRecord call-back.
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      return str.split('-').slice(0...-1).join('-') + "-" + count.to_s
    else
      return str + "-" + count.to_s
    end
  end

  def to_slug(name)
    name.downcase.gsub!(/[^a-z1-9]+/, '-').chomp('-')
  end

  def to_param # This overwrites the 'to_param' method (That is called by default in the views with something like: 'edit_post_path(@post)').  It is overridden so that the slug can be executed.
    self.slug
  end

end


