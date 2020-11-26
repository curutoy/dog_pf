class DogsController < ApplicationController
  before_action :authenticate_any!, except: [:index]

  def new
    @dog = Dog.new
  end

  def create
    @dog = Dog.new(dog_params)
    @dog.protector_id = current_protector.id
    @dog.save
    redirect_to root_path
  end

  def index
    if user_signed_in? || protector_signed_in?
      render :index
    else
      render template: "home/index"
    end
    @dogs = Dog.all
  end

  def show
    @dog = Dog.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def dog_params
    params.require(:dog).permit(:protector_id, :name, :age, :address, :gender, :size,
                                :profile, :walking, :caretaker, :relationsip_dog, :relationsip_prople,
                                :castration, :vaccine, :microchip, :conditions, :single_people, :senior, :image)
  end
end
