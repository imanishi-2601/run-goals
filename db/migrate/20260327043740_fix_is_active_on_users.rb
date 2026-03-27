class FixIsActiveOnUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :is_active, from: nil, to: true
    change_column_null :users, :is_active, false, true
  end
end
