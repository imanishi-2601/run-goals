class CommunitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @communities = Community.all
  end

  def show
    @community = Community.find(params[:id])
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

  end

  def destroy

  end

  def search
    if params[:keyword].present?
      @communities = Community.where(
        "name LIKE ? OR introduction LIKE ?",
        "%#{params[:keyword]}%",
        "%#{params[:keyword]}%"
      )
    else
      @communities = Community.none
      flash.now[:alert] = "キーワードを入力してください"
      render :index
   end
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

  def community_params
    params.require(:community).permit(:name, :introduction)
  end
end