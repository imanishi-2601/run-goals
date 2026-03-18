class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
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
    @user.destroy
    reset_session
    redirect_to root_path, notice: "退会しました"
  end


  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end