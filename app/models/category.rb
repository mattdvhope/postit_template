class Category < ActiveRecord::Base
  has_many :subjects
  has_many :posts, through: :subjects

  validates :name, presence: true

  before_save :generate_slug!
  before_save :capitalize_name

  def capitalize_name
    self.name = self.name.capitalize
  end

  def generate_slug! #.slug method comes from the 'slug' column(virtual attribute) in the 'posts' table.
    the_slug = to_slug(self.name)
    category = Category.find_by slug: the_slug
    count = 2
    while category && category != self
      the_slug = append_suffix(the_slug, count) #the_slug + "-" + count.to_s
      category = Category.find_by slug: the_slug
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
    name.strip.downcase.gsub(/\s*[^a-z0-9]\s*/, '-').gsub /-+/, "-"
  end

  def to_param
    self.slug
  end

end
