class Category < ActiveRecord::Base
  include Sluggable #mix-in Module in /lib/sluggable.rb (generate_slug, append_suffix, to_slug, to_param) ; Already went to config/application.rb and inserted: config.autoload_paths += %W(#{config.root}/lib).

  has_many :subjects
  has_many :posts, through: :subjects

  validates :name, presence: true

  before_save :generate_slug!
  before_save :capitalize_name

  def capitalize_name
    self.name = self.name.capitalize
  end

  sluggable_column :name # Because the 'categories' table has the 'name' column.  The 'posts' & the 'users' tables have different column names that will be used in 'lib/sluggable.rb'.
# sluggable_column is a method is lib/sluggable.rb

end
