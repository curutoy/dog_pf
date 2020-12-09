class PetsController < ApplicationController
  before_action :authenticate_user!
  before_action :right_user

  def new
    @user = User.find(params[:user_id])
    @pet = Pet.new
  end

  def create
    @user = User.find(params[:user_id])
    @pet = Pet.new(pet_params)
    @pet.user_id = @user.id
    respond_to do |format|
      if @pet.save
        format.html { redirect_to @user }
        format.js { @status = "success" }
      else
        format.html { render 'users/show' }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @pet = Pet.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @pet = Pet.find(params[:id])
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @user }
        format.js { @status = "success" }
      else
        format.html { render 'users/show' }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
    @pet = Pet.find(params[:id])
    respond_to do |format|
      @pet.destroy
      format.html { redirect_to dog_path @dog }
      format.js { @status = "success" }
    end
  end

  private

  def post_params
    params.require(:pet).permit(:user_id, :age, :gender, :character, :image)
  end

  def right_protector
    @user = User.find(params[:user_id])
    if @user != current_user
      redirect_to @user
      flash[:alert] = "投稿者のみ閲覧できるページです。"
    end
  end
end
