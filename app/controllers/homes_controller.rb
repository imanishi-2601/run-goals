class HomesController < ApplicationController
  def top
    @posts = Post.limit(5)
  end
end