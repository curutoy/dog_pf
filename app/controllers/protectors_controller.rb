class ProtectorsController < ApplicationController
  before_action :authenticate_protector!
  before_action :authenticate_user!

  def show
    @protector = Protector.find(params[:id])
  end
end
