class CommunityMembershipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @community = Community.find(params[:community_id])
    @memberships = @community.community_memberships.approved
    @pending_memberships = @community.community_memberships.pending
    @approved_memberships = @community.community_memberships.approved
    # コミュニティに参加していない場合は閲覧不可
    unless current_user.community_memberships.exists?(community_id: @community.id, status: :approved)
      redirect_to community_path(@community), alert: "メンバー一覧を見るにはコミュニティ参加が必要です。"
      return
    end
  end

  def show
    @community = Community.find(params[:id])

    @community_membership = current_user.community_memberships.find_by(community_id: @community.id)

  end

  def create
    @community = Community.find(params[:community_id])
    membership = @community.community_memberships.new(
      user: current_user,
      community: @community,
      status: :pending
    )

    if membership.save
      redirect_to community_path(@community), notice: "参加申請を送信しました。"
    else
      redirect_to community_path(@community), alert: "参加申請に失敗しました。"
    end
  end

  def update
    @community = Community.find(params[:community_id])
    membership = @community.community_memberships.find(params[:id])

    unless @community.user == current_user
      redirect_to community_path(@community), alert: "権限がありません。"
      return
    end

    if membership.update(status: :approved)
      redirect_to community_community_memberships_path(@community), notice: "承認しました。"
    else
      redirect_to community_community_memberships_path(@community), alert: "更新に失敗しました。"
    end
  end
end