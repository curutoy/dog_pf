class PostsController < ApplicationController
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
        format.html { redirect_to @dog, notice: "投稿しました" }
        format.json { render :show, status: created, location: @dog }
        format.js { @status = "success" }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
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
