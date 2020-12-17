class UsersController < ApplicationController
  before_action :authenticate_any!

  def show
    @user = User.find(params[:id])
    @relationships = @user.relationships
    @entryrotector = Entry.where(protector_id: current_protector.id)
    @entryuser = Entry.where(user_id: @user.id)
    @entryprotector.each do |p|
      @entryuser.each do |u|
        if p.room_id == u.room_id
          @isroom = true
          @roomid = p.room_id
        end
      end
    end
    unless @isroom
      @room = Room.new
      @entry = Entry.new
    end
  end
end
