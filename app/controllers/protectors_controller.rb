class ProtectorsController < ApplicationController
  before_action :authenticate_any!
  def show
    @protector = Protector.find(params[:id])
    @dogs = @protector.dogs
  end
end
