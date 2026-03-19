class Admins::CommunitiesController < ApplicationController
  # before_action :authenticate_admins!
  def top

  end

  def index
    @communities = Community.all
  end
end