class DogsController < ApplicationController
  before_action :authenticate_protector!
  before_action :authenticate_user!
  def index
  end
end
