class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @protector = Protector.find(params[:protector_id])
    unless @protector.follow?(current_user)
      @protector.follow(current_user)
      @protector.create_notification_follow!(current_user)
      respond_to do |format|
        format.html { redirect_to @protector }
        format.js
      end
    end
  end

  def destroy
    @protector = Relationship.find(params[:id]).protector
    if @protector.follow?(current_user)
      @protector.unfollow(current_user)
      respond_to do |format|
        format.html { redirect_to @protector }
        format.js
      end
    end
  end
end
