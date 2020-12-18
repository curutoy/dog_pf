class RoomsController < ApplicationController
  before_action :authenticate_any!

  def create
    @room = Room.create
    if protector_signed_in?
      @entry = Entry.create(params_entry_protector)
      redirect_to room_path(@room.id)
    else
      @entry = Entry.create(params_entry_user)
      redirect_to room_path(@room.id)
    end
  end

  def index
    @entries = Entry.all.includes(:room)
  end

  def show
    @room = Room.find(params[:id])
    if protector_signed_in?
      if Entry.where(protector_id: current_protector.id, room_id: @room.id).present?
        @messages = @room.messages
        @message = Message.new
        @entries = @room.entries
      else
        redirect_to root_path
      end
    else
      if Entry.where(user_id: current_user.id, room_id: @room.id).present?
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
    params.require(:entry).permit(:protector_id, :user_id, :room_id).merge(protector_id: current_protector.id, room_id: @room.id)
  end

  def params_entry_user
    params.require(:entry).permit(:protector_id, :user_id, :room_id).merge(user_id: current_user.id, room_id: @room.id)
  end
end
