class Admins::CommunitiesController < ApplicationController
  # before_action :authenticate_admins!
  def top

  end

  def index
    @communities = Community.all
  end

  def show
    @community = Community.find(params[:id])
  end
end