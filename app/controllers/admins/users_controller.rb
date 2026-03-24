class Admins::UsersController < Admins::BaseController
  def index
    @users = User.all
  end

  def show
    @users = User.all
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.admin? || current_user == @user
      redirect_to admins_users_path, alert: "このユーザーは変更できません。"
      return
    end

    @user.update!(is_active: !@user.is_active)

    message = @user.is_active ? "利用を再開しました。" : "利用停止にしました。"
    redirect_to admins_users_path, notice: message
  end

  def destroy
  end
end
