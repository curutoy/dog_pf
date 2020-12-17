class ProtectorsController < ApplicationController
  before_action :authenticate_any!

  def show
    @protector = Protector.find(params[:id])
    @dogs = @protector.dogs
    @relationships = @protector.relationships
    @entryuser = Entry.where(user_id: current_user.id)
    @entryprotector = Entry.where(protector_id: @protector.id)
    @entryuser.each do |u|
      @entryprotector.each do |p|
        if u.room_id == p.room_id
          @isroom = true
          @roomid = u.room_id
        end
      end
    end
    unless @isroom
      @room = Room.new
      @entry = Entry.new
    end
  end
end
