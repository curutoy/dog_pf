class DogsController < ApplicationController
  before_action :authenticate_protector!, except: [:index, :show]
  before_action :authenticate_any!, only: [:show]
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
    if user_signed_in? || protector_signed_in?
      @dogs = Dog.all
      render :index
    else
      render template: "home/index"
    end
  end

  def show
    @dog = Dog.find(params[:id])
    @posts = @dog.posts
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
  end

  private

  def dog_params
    params.require(:dog).permit(:protector_id, :name, :age, :address, :gender, :size, :profile,
                                :walking, :caretaker, :relationship_dog, :relationship_people, :health,
                                :castration, :vaccine, :microchip, :conditions, :single_people, :senior, :image)
  end

  def authenticate_protector!
    if user_signed_in?
      redirect_to root_path
      flash[:alert] = "保護活動家専用のページです"
    elsif protector_signed_in?
    else
      render template: "home/index"
      flash[:alert] = "ログインまたはアカウント登録を行ってください"
    end
  end

  def right_protector
    @dog = Dog.find(params[:id])
    if @dog.protector_id != current_protector.id
      redirect_to root_path
      flash[:alert] = "投稿者のみ閲覧できるページです。"
    end
  end
end
