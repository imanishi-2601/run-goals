class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :communities

  # membership=>単数か複数か
  has_many :community_membership, dependent: :destroy
  has_many :joined_communities, through: :community_membership, source: :community

  has_many :community_memberships, dependent: :destroy
  has_many :joined_communities, through: :community_memberships, source: :community

  has_many :posts

  def status_label
    is_active ? "有効" : "退会済み"
  end
end
