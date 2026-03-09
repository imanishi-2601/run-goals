class UserName < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community, foreign_key: true

      t.date :date
      t.string :user.name
      t.decimal :distance
      t.integer :time
      t.integer :rpe
      t.text :memo
      t.boolean :is_public
  end
end
