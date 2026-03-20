require "test_helper"

class Admins::CommunityMembershipControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_community_membership_index_url
    assert_response :success
  end
end
