class ApplicationController < ActionController::Base
  before_action :authenticate_user! || :authenticate_protector!
end
