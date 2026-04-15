class Community < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :introduction, presence: true

  has_many :community_memberships, dependent: :destroy
  has_many :members, through: :community_memberships, source: :user
  has_many :posts, dependent: :destroy
end