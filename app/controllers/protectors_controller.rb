class ProtectorsController < ApplicationController
  def show
    @protector = Protector.find(params[:id])
  end
end
