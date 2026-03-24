class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_user_active

  protected
  # サインイン後のリダイレクト先
  # ユーザーが作成したコミュニティの保留中の参加申請がある場合はマイページへ、ない場合はコミュニティ一覧へ
  def after_sign_in_path_for(resource)
    if resource.admin?
      admins_root_path
    else
      pending_memberships = CommunityMembership
        .joins(:community)
        .where(communities: { user_id: resource.id })
        .where(status: :pending)

      if pending_memberships.exists?
        user_path(resource)
      else
        communities_path
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private
  # 停止ユーザーのログインを防止するメソッド
  def check_user_active
    return unless user_signed_in?

    unless current_user.is_active
      sign_out(current_user)
      redirect_to new_user_session_path, alert: "このアカウントは利用停止中です。"
    end
  end
end