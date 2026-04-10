class CommunitiesController < ApplicationController
  before_action :authenticate_user!
  # コミュニティの各アクションの前にコミュニティをセット
  before_action :set_community, only: [:show, :edit, :update, :destroy,
                                       :request_owner_transfer, :accept_owner_transfer, :reject_owner_transfer]
  # コミュニティの編集、更新、削除、管理者移行依頼は作成者のみ可能
  before_action :ensure_owner!, only: [:edit, :update, :destroy, :request_owner_transfer]

  def index
    @communities = Community.all
  end

  def show
    @community_membership = current_user.community_membership.find_by(community: @community)
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user

    if @community.save
      @community.community_memberships.create(user: current_user, status: :approved)
      redirect_to communities_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to community_path(@community), notice: "コミュニティを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @community.destroy
    redirect_to communities_path, notice: "コミュニティを削除しました。"
  end

    # 管理者移行依頼のアクション
  def request_owner_transfer
    @community = Community.find(params[:id])

    # 権限チェック（作成者のみ）
    unless @community.user_id == current_user.id
      redirect_to community_community_memberships_path(@community), alert: "権限がありません"
      return
    end

    new_owner = User.find(params[:new_owner_id])

    # メンバーか確認
    membership = @community.community_memberships.find_by(user_id: new_owner.id)

    unless membership&.approved?
      redirect_to community_community_memberships_path(@community), alert: "参加中メンバーのみ管理者にできます"
      return
    end

    @community.update(pending_owner_id: new_owner.id)

    redirect_to community_community_memberships_path(@community),
              notice: "管理者変更を#{new_owner.name}さんに依頼しました"
  end

    # 管理者移行依頼を受けたユーザーが承認するためのアクション
  def accept_owner_transfer
    @community = Community.find(params[:id])

    unless @community.pending_owner_id == current_user.id
      redirect_to community_path(@community), alert: "この依頼を承認する権限がありません"
      return
    end

    @community.update(
      user_id: current_user.id,
      pending_owner_id: nil
    )

    redirect_to community_path(@community), notice: "管理者を引き継ぎました"
  end

  # 管理者移行依頼を受けたユーザーが辞退するためのアクション
  def reject_owner_transfer
    @community = Community.find(params[:id])

    unless @community.pending_owner_id == current_user.id
      redirect_to community_path(@community), alert: "この依頼を辞退する権限がありません"
      return
    end

    @community.update(pending_owner_id: nil)

    redirect_to community_path(@community), notice: "管理者変更依頼を辞退しました"
  end

private
  def set_community
    @community = Community.find(params[:id])
  end
  def ensure_owner!
    return if @community.user_id == current_user.id
    redirect_to community_path(@community), alert: "権限がありません"
  end
  def community_params
    params.require(:community).permit(:name, :introduction)
  end
end