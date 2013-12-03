class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.integer :category_id
      t.integer :post_id

      t.timestamps
    end
  end
end
