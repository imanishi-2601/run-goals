class Admins::UsersController < Admins::BaseController
  def index
    @users = User.all
  end

  def show
    @users = User.all
    @user = User.find(params[:id])
  end

  # 利用停止/再開のアクション
  def update
    @user = User.find(params[:id])

    if @user.admin? || current_user == @user
      redirect_to admins_user_path(@user), alert: "このユーザーは変更できません。"
      return
    end

    @user.update!(is_active: !@user.is_active)

    message = @user.is_active ? "利用を再開しました。" : "利用停止にしました。"
    redirect_to admins_user_path(@user), notice: message
  end

  # 退会処理のアクション
  def destroy
    @user = User.find(params[:id])

    if @user.is_active
      redirect_to admins_user_path(@user), alert: "利用停止中のユーザーのみ退会可能です。"
      return
    end

    @user.destroy
    redirect_to admins_users_path, notice: "ユーザーを退会処理しました。"
  end
end
