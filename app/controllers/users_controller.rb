class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    # 投稿時に入力した日付で並ぶ/同じ日付なら投稿作成が新しい方を上にする
    @posts = current_user.posts.order(date: :desc, created_at: :desc)

    # ユーザーが作成したコミュニティの保留中の参加申請を取得
    @pending_memberships = CommunityMembership
      .joins(:community)
      .where(communities: { user_id: @user.id })
      .where(status: :pending)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user

    owned_communities = Community.where(user_id: @user.id)

    if owned_communities.exists?
      redirect_to user_path(@user), alert: "管理者のコミュニティが残っているため退会できません。管理者移行を完了してください。"
      return
    end

    @user.destroy
    reset_session
    redirect_to root_path, notice: "退会しました"
  end


  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end