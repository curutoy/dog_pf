class FavoritesController < ApplicationController
  before_action :authenticate_any!
  before_action :right_user, only: [:index]

  def create
    @dog = Dog.find(params[:dog_id])
    unless @dog.like?(current_user)
      @dog.like(current_user)
      @dog.create_notification_like!(current_user)
      respond_to do |format|
        format.html { redirect_to @dog }
        format.js
      end
    end
  end

  def index
    @favorites = Favorite.where(user_id: current_user.id).includes(dog: [image_attachment: :blob])
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

  private

  def right_user
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to root_path
      flash[:alert] = "登録者のみ閲覧できるページです。"
    end
  end
end
