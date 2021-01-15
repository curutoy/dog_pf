class DogsController < ApplicationController
  before_action :authenticate_protector!, only: [:new, :create]
  before_action :authenticate_any!, only: [:edit, :update, :destroy]
  before_action :right_protector, only: [:edit, :update, :destroy]

  def new
    @dog = Dog.new
  end

  def create
    @dog = Dog.new(dog_params)
    @dog.protector_id = current_protector.id
    if @dog.save
      redirect_to root_path
    else
      render :new
    end
  end

  def index
    @search_params = dogs_search_params
    @dogs = Dog.search(@search_params).includes(image_attachment: :blob).paginate(params).per(20).sorted
    render :index
  end

  def show
    @dog = Dog.find(params[:id])
    @favorites = @dog.favorites.includes(user: [image_attachment: :blob]).references(:favorite)
    @posts = @dog.posts.includes(image_attachment: :blob).references(:post).order('posts.id DESC')
  end

  def edit
    @dog = Dog.find(params[:id])
  end

  def update
    @dog = Dog.find(params[:id])
    if @dog.update(dog_params)
      redirect_to @dog
    else
      render :edit
    end
  end

  def destroy
    @dog = Dog.find(params[:id])
    @dog.destroy
    redirect_to root_path
  end

  private

  def dog_params
    params.require(:dog).permit(:protector_id, :name, :age, :address, :gender, :size, :profile,
                                :walking, :caretaker, :relationship_dog, :relationship_people, :health,
                                :castration, :vaccine, :microchip, :conditions, :single_people, :senior, :image)
  end

  def dogs_search_params
    params.fetch(:search, {}).permit(:address, :gender, :size)
  end

  def authenticate_protector!
    if user_signed_in?
      redirect_to root_path
      flash[:alert] = "保護活動家専用のページです"
    elsif protector_signed_in?
    else
      render template: "homes/index"
      flash[:alert] = "ログインまたはアカウント登録を行ってください"
    end
  end

  def right_protector
    @dog = Dog.find(params[:id])
    if user_signed_in? || @dog.protector_id != current_protector.id
      redirect_to root_path
      flash[:alert] = "投稿者のみ閲覧できるページです。"
    end
  end
end
