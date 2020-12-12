class UsersController < ApplicationController
  before_action :authenticate_any!

  def show
    @user = User.find(params[:id])
    @relationships = @user.relationships
  end
end
