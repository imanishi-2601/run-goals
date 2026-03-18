class SearchController < ApplicationController
  def index
    @q = params[:q]
    @match = params[:match]
    @scope = params[:scope]

    if @scope == "communities"
      @communities = Community.where("name LIKE ?", "%#{@q}%")
    end
  end

    def search
    @q = params[:q]
    @match = params[:match]
    @scope = params[:scope]

    if @scope == "communities"
      @communities = Community.where("name LIKE ?", "%#{@q}%")
    end
  end
end