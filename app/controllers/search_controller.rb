class SearchController < ApplicationController
  def index
    @keyword = params[:keyword]

    # 未入力検索時のエラーメッセージ表示
    if @keyword.blank?
      flash.now[:alert] = "キーワードを入力してください"
      @communities = []
      return
    end

    @communities = Community.where("name LIKE ?", "%#{@keyword}%")

  end
end