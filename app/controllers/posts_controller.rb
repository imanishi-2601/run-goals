class PostsController < ApplicationController
  before_action :authenticate_user!
  # 投稿の各アクションの前に投稿をセット(set_postを実行)
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # 投稿の編集、更新、削除時に投稿者であることを確認
  before_action :ensure_post_owner, only: [:edit, :update, :destroy]

  before_action :set_community_from_params, only: [:index, :new, :create]

  before_action :ensure_joined_community!, only: [:new, :create]

  def index
    if params[:community_id].present?
      @community = Community.find(params[:community_id])

    # コミュニティに紐づく投稿のベース（共通部分）
    # 投稿時に入力した日付で並ぶ / 同じ日付なら投稿作成が新しい方を上にする
    base_posts = Post.includes(:user, :community)
                     .where(community_id: @community.id)
                     .order(date: :desc, created_at: :desc)

    # コミュニティ参加状態によって表示内容を分岐
    if current_user.community_memberships.exists?(community_id: @community.id, status: :approved)
      # 参加しているユーザー → 投稿をすべて表示
      @posts = base_posts
      @limited_posts = false
    else
      # 未参加ユーザー → 投稿は一部（5件）のみ表示
      @posts = base_posts.limit(5)
      @limited_posts = true
    end

  else
    # community_idがない場合（全体投稿一覧など）
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
  # community_idがある場合にコミュニティを取得する
  def set_community_from_params
    @community = Community.find_by(id: params[:community_id])
  end
  # コミュニティに参加していない場合は弾く
  def ensure_joined_community!
    return if @community.blank?
    return if current_user.community_memberships.exists?(community_id: @community.id, status: :approved)
    redirect_to community_posts_path(@community), alert: "このコミュニティに参加していないため投稿できません。"
  end
end