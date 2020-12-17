class RoomsController < ApplicationController
  before_action :authenticate_any!

  def create
    @room = Room.create
    if protector_signed_in?
      @entry1 = Entry.create(room_id: @room.id, protector_id: current_protector.id)
      @entry2 = Entry.create(params_entry_protector)
      redirect_to "/rooms/#{@room.id}"
    else
      @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
      @entry2 = Entry.create(params_entry_user)
      redirect_to "/rooms/#{@room.id}"
    end
  end

  def show
    @room = Room.find(params[:id])
    if protector_signed_in?
      if Emtry.where(protector_id: current_protector.id, room_id: @room.id).present?
        @messages = @room.messages
        @message = Message.new
        @entries = @room.entries
      else
        redirect_to root_path
      end
    else
      if Emtry.where(user_id: current_user.id, room_id: @room.id).present?
        @messages = @room.messages
        @message = Message.new
        @entries = @room.entries
      else
        redirect_to root_path
      end
    end
  end

  private

  def params_entry_protector
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end

  def params_entry_user
    params.require(:entry).permit(:protector_id, :room_id).merge(room_id: @room.id)
  end
end
