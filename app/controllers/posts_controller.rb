class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    if params[:community_id]
      @community = Community.find(params[:community_id])

      @posts = Post.joins(:user)
                  .joins("INNER JOIN community_memberships
                        ON community_memberships.user_id = users.id")
                  .where(community_memberships: { community_id: @community.id })

    else
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    total_sec = Post.to_sec(
      params[:hour].to_i,
      params[:min].to_i,
      params[:sec].to_i
    )

    @post = current_user.posts.new(post_params)
    @post.time = total_sec


    if @post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

    private

  def post_params
    params.require(:post).permit(
      :date,
      :name,
      :distance,
      :time,
      :memo,
      :is_public
    )
  end
end
