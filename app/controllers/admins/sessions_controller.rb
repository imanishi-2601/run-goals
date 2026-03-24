class Admins::SessionsController < ApplicationController
  def new
  end

  def create
  end

  def destroy
    sign_out(current_user)
    redirect_to admins_sign_in_path, notice: "ログアウトしました。"
  end
end