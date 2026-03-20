class Admins::PostsController < ApplicationController
  def index
    @community = Community.find(params[:community_id])
    @posts = @community.posts
  end
end
