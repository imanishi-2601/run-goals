class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(@user)  # Devise標準のサインイン処理を呼ぶ
      # session[:user_id] = @user.id
      redirect_to communities_path
    else
      Rails.logger.debug @user.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
