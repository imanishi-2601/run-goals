class CommunitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @communities = Community.all
  end

  def show
    @community = Community.find(params[:id])
    @community_membership = current_user.community_membership.find_by(community: @community)
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user

    if @community.save
      redirect_to communities_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  def search
    if params[:keyword].present?
      @communities = Community.where(
        "name LIKE ? OR introduction LIKE ?",
        "%#{params[:keyword]}%",
        "%#{params[:keyword]}%"
      )
    else
      @communities = Community.none
   end
  end

private

  def community_params
    params.require(:community).permit(:name, :introduction)
  end
end