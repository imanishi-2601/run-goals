class PostsController < ApplicationController
  before_action :authenticate_user!
  # 投稿の各アクションの前に投稿をセット(set_postを実行)
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # 投稿の編集、更新、削除時に投稿者であることを確認
  before_action :ensure_post_owner, only: [:edit, :update, :destroy]

  def index
    if params[:community_id].present?
      @community = Community.find(params[:community_id])

      # コミュニティに所属しているユーザーの投稿のみを表示
      # 投稿時に入力した日付で並ぶ/同じ日付なら投稿作成が新しい方を上にする
      @posts = Post.includes(:user, :community)
                 .where(community_id: @community.id)
                 .order(date: :desc, created_at: :desc)
    else
      @posts = Post.includes(:user, :community)
                 .order(date: :desc, created_at: :desc)
    end
  end

  def show
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
      redirect_to post_path(@post), notice: "投稿を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    total_sec = Post.to_sec(
      params[:hour].to_i,
      params[:min].to_i,
      params[:sec].to_i
    )

    @post.time = total_sec

    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
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
      :is_public,
      :community_id
    )
  end

  # 投稿を@postにセットするメソッド(各アクション前の動作)
  def set_post
    @post = Post.find(params[:id])
  end
  # 投稿を@postにセットするメソッド
  def ensure_post_owner
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: "権限がありません。"
    end
  end
end