class CommunityMembershipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @community = Community.find(params[:community_id])
    @memberships = @community.community_memberships.includes(:user)
  end

  def create
    @community = Community.find(params[:community_id])
    membership = @community.community_memberships.new(
      user: current_user,
      status: 1
    )

    if membership.save
      redirect_to community_path(@community), notice: "参加申請しました"
    else
      redirect_to community_path(@community), alert: "申請できませんでした"
    end
  end
end