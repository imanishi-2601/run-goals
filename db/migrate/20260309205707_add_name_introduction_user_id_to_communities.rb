class AddNameIntroductionUserIdToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :name, :string
    add_column :communities, :introduction, :text
    add_column :communities, :user_id, :integer
  end
end
