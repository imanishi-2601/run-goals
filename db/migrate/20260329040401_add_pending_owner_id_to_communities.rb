class AddPendingOwnerIdToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :pending_owner_id, :integer
  end
end
