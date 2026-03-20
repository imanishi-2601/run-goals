require "test_helper"

class Admins::PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_posts_index_url
    assert_response :success
  end
end
