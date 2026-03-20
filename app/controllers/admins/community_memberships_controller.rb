class Admins::CommunityMembershipsController < ApplicationController
  def index
    @community = Community.find(params[:community_id])
    @memberships = @community.community_memberships
  end
end
