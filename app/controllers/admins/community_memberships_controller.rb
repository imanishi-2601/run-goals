class Admins::CommunityMembershipsController < Admins::BaseController
  def index
    @community = Community.find(params[:community_id])
    @memberships = @community.community_memberships
  end
end
