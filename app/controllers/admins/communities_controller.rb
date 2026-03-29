class Admins::CommunitiesController < Admins::BaseController
  # before_action :authenticate_admins!
  def top

  end

  def index
    @communities = Community.all
  end

  def show
    @community = Community.find(params[:id])
  end

  def destroy
    @community = Community.find(params[:id])
    @community.destroy
    redirect_to admins_communities_path, notice: "コミュニティを削除しました。"
  end

end