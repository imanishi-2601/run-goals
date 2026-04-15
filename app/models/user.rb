class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true # ユーザー名は必須
  has_many :communities

  # membership=>単数か複数か
  has_many :community_membership, dependent: :destroy
  has_many :joined_communities, through: :community_membership, source: :community

  has_many :community_memberships
  # コミュニティに参加しているかどうかを確認するメソッド
  def joined_community?(community)
    community_memberships.exists?(community_id: community.id, status: :approved)
  end

  has_many :posts

  # ステータス
  def status_label
    if withdrawn_at.present?
      "退会済み"
    elsif is_active
      "有効"
    else
      "利用停止"
    end
  end

  # 停止ユーザーをログイン不可にするためのメソッド
  def active_for_authentication?
    is_active
  end
  def inactive_message
    is_active ? super : :inactive
  end

end
