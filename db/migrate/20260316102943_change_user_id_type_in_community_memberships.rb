class ChangeUserIdTypeInCommunityMemberships < ActiveRecord::Migration[8.0]
  def change
    change_column :community_memberships, :user_id, :bigint
    change_column :community_memberships, :community_id, :bigint
    change_column :posts, :user_id, :bigint
    change_column :posts, :community_id, :bigint
  end
end
