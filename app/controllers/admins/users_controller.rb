class Admins::UsersController < Admins::BaseController
  def index
    @users = User.all
  end

  def show
  end

  def destroy
  end
end
