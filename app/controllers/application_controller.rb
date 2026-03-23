class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  # サインイン後のリダイレクト先
  # ユーザーが作成したコミュニティの保留中の参加申請がある場合はマイページへ、ない場合はコミュニティ一覧へ
  def after_sign_in_path_for(resource)
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

  def after_sign_up_path_for(resource)
    communities_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end