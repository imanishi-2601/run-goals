class Admins::BaseController < ApplicationController
  before_action :authenticate_admin!
  layout "admins"

  private

  def authenticate_admin!
    unless user_signed_in?
      redirect_to admins_sign_in_path, alert: "管理者としてログインしてください。"
      return
    end

    unless current_user.admin?
      redirect_to root_path, alert: "管理者のみアクセスできます。"
    end
  end

  #def ensure_admin
    #redirect_to root_path unless current_user&.admin?
  #end
end