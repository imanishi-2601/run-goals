class Admins::SessionsController < ApplicationController
    def destroy
    session.delete(:user_id)
    redirect_to admins_sign_in_path
  end
end