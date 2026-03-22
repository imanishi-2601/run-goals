class Admins::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  layout "admins"

  private

  def ensure_admin
    redirect_to root_path unless current_user&.admin?
  end
end