class DogsController < ApplicationController
  before_action :authenticate_any!, except: [:index]

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
end
