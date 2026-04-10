class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @keyword = params[:keyword].to_s.strip
    @match   = params[:match].presence || "partial"
    @scope   = params[:scope].presence || "communities"

    @communities = Community.none

    if @keyword.blank?
      flash.now[:alert] = "キーワードを入力してください"
      return
    end

    pattern = build_pattern(@keyword, @match)

    if @scope == "communities"
      @communities = Community.where(
        "name LIKE :pattern OR introduction LIKE :pattern",
        pattern: pattern
      )
    end
  end

  private

  def build_pattern(raw_keyword, match)
    escaped_keyword = ActiveRecord::Base.sanitize_sql_like(raw_keyword)

    case match
    when "exact"
      escaped_keyword
    when "prefix"
      "#{escaped_keyword}%"
    when "suffix"
      "%#{escaped_keyword}"
    else
      "%#{escaped_keyword}%"
    end
  end
end