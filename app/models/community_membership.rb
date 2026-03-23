class CommunityMembership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  #重複申請を防ぐ
  validates :user_id, uniqueness: { scope: :community_id }
end