class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @dog = Dog.find(params[:dog_id])
    unless @dog.like?(current_user)
      @dog.like(current_user)
      respond_to do |format|
        format.html { redirect_to @dog }
        format.js
      end
    end
  end

  def destroy
    @dog = Favorite.find(params[:id]).dog
    if @dog.like?(current_user)
      @dog.unlike(current_user)
      respond_to do |format|
        format.html { redirect_to @dog }
        format.js
      end
    end
  end
end
