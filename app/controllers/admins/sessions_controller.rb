class Admins::SessionsController < Admins::BaseController
  skip_before_action :authenticate_admin!, only: [:new, :create, :destroy]

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password]) && user.admin?
      sign_in(user)
      redirect_to admins_root_path   # ← noticeを書かない
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(:user)
    redirect_to admins_sign_in_path, notice: "ログアウトしました。"
  end
end