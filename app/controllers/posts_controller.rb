class PostsController < ApplicationController
  before_action :authenticate_protector!
  before_action :right_protector, only: [:new, :create, :destroy]

  def new
    @dog = Dog.find(params[:dog_id])
    @post = Post.new
  end

  def create
    @dog = Dog.find(params[:dog_id])
    @post = Post.new(post_params)
    @post.dog_id = @dog.id
    respond_to do |format|
      if @post.save
        format.html { redirect_to @dog }
        format.js { @status = "success" }
      else
        format.html { render 'dogs/show' }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
    @dog = Dog.find(params[:dog_id])
    @post = Post.find(params[:id])
    respond_to do |format|
      @post.destroy
      format.html { redirect_to dog_path @dog }
      format.js { @status = "success" }
    end
  end

  private

  def post_params
    params.require(:post).permit(:dog_id, :content, :image)
  end

  def right_protector
    @dog = Dog.find(params[:dog_id])
    if @dog.protector != current_protector
      redirect_to @dog
      flash[:alert] = "投稿者のみ閲覧できるページです。"
    end
  end
end
