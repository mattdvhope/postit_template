class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :vote
      t.integer :user_id
    # t.references :votable, polymorphic: true  #means the same as lines 7 & 8
      t.string :voteable_type
      t.integer :voteable_id
      t.timestamps
    end
  end
end
