class MessagesController < ApplicationController
  before_action :authenticate_any!

  def create
    if protector_signed_in?
      if Entry.where(protector_id: current_protector.id, room_id: params[:message][:room_id]).present?
        @message = Message.create(params_message_protector)
      else
        flash[:alert] = "メッセージ送信に失敗しました"
      end
      redirect_to "/rooms/#{@message.room_id}"
    else
      if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
        @message = Message.create(params_message_user)
      else
        flash[:alert] = "メッセージ送信に失敗しました"
      end
      redirect_to "/rooms/#{@message.room_id}"
    end
  end

  private

  def params_message_protector
    params.require(:message).permit(:protector_id, :user_id, :content, :room_id).merge(protector_id: current_protector.id)
  end

  def params_message_user
    params.require(:message).permit(:protector_id, :user_id, :content, :room_id).merge(user_id: current_user.id)
  end
end
