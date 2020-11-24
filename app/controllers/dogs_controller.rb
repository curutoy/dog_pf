class DogsController < ApplicationController
  def index
    if user_signed_in? || protector_signed_in?
      render :index
    else
      render template: "home/index"
    end
  end
end
