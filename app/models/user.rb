class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :communities

  has_many :community_membership, dependent: :destroy
  has_many :joined_communities, through: :community_membership, source: :community

  has_many :posts
end
