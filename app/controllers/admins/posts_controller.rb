class Admins::PostsController < Admins::BaseController
  def index
    @community = Community.find(params[:community_id])
    @posts = @community.posts
  end
end
