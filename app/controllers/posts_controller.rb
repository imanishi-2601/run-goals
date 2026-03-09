class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to posts_path
    else
      Rails.logger.debug @post.errors.full_messages
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
