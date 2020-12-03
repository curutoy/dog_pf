class PostsController < ApplicationController
  def new
    @dog = Dog.find(params[:dog_id])
    @post = Post.new
  end

  def create
    @dog = Dog.find(params[:dog_id])
    @post = Post.new(post_params)
    @post.dog_id = @dog.id
    if @post.save
      redirect_to dog_path @dog
    else
      render 'posts/new'
    end
  end

  def show
    @dog = Dog.find(params[:dog_id])
    @post = Post.find(params[:id])
  end

  def destroy
    @dog = Dog.find(params[:dog_id])
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to dog_path @dog
    flash[:notice] = "投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:dog_id, :content, :image)
  end
end
