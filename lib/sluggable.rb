module Sluggable # This code is extracted from post.rb, category.rb & user.rb models. Use 'self.class.' to work with all three classes.
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column # Used to save the col_name below.
  end

  def generate_slug! #.slug method comes from the 'slug' column in the 'posts' table.
    the_slug = to_slug(self.send(self.class.slug_column.to_sym)) # 1. We first generated/sluggify a new slug | self.send(self.class.slug_column.to_sym) is the replacement for 'self.title' or 'self.name' or 'self.username'.
    obj = self.class.find_by slug: the_slug # 2. We then look in our db for an already-existing slug of the_slug's [same] name.
    count = 2
    while obj && obj != self # We're saying here... "While the obj exists, but it's not the same object as we're dealing with. We don't want to append an additional number if we're dealing with the same obj object."
      the_slug = append_suffix(the_slug, count) #the_slug + "-" + count.to_s
      obj = self.class.find_by slug: the_slug
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
               # to_param evalutes to id by default (like in posts/_post.html.erb in post_path(post) [where 'post' is the argument rather than post.id]).
  def to_param # This overwrites the 'to_param' method (That is called by default in the views with something like: 'edit_post_path(@post)').  It is overridden so that the slug can be executed.
    self.slug #.slug method comes from the 'slug' column in the 'posts' table.
  end

  module ClassMethods
    def sluggable_column(col_name) # We're trying to expose a class method for the class that's including this module to set the column name to use; then we're saving the column name to an attribute ('class_attribute', above) that we can now reference in our code here, in our instance methods.
      self.slug_column = col_name # This assigns the perticular class' column name to the class_attribute above.
    end

  end

end