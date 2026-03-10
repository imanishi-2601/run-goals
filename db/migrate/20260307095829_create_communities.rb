class CreateCommunities < ActiveRecord::Migration[8.0]
  def change
    create_table :communities do |t|
      t.integer :user_id
      t.string :name
      t.text :introduction

      t.timestamps
    end
  end
end
