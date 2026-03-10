require "test_helper"

class CommunityMembershipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get community_memberships_index_url
    assert_response :success
  end

  test "should get create" do
    get community_memberships_create_url
    assert_response :success
  end

  test "should get update" do
    get community_memberships_update_url
    assert_response :success
  end

  test "should get destroy" do
    get community_memberships_destroy_url
    assert_response :success
  end
end
