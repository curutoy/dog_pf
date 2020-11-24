class ApplicationController < ActionController::Base
  def authenticate_any!
    if protector_signed_in?
        true
    else
        authenticate_user!
    end
  end
end
