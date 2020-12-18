class MessagesController < ApplicationController
  before_action :authenticate_any!

  def create
    if protector_signed_in?
      @message = Message.new(params_message_protector)
      if @message.save
        redirect_to room_path(@message.room_id)
      else
        flash[:alert] = "メッセージ送信に失敗しました"
        redirect_to room_path(@message.room_id)
      end
    else
      @message = Message.new(params_message_user)
      if @message.save
        redirect_to room_path(@message.room_id)
      else
        flash[:alert] = "メッセージ送信に失敗しました"
        redirect_to room_path(@message.room_id)
      end
    end
  end

  private

  def params_message_protector
    params.require(:message).permit(:protector_id, :content, :room_id).merge(protector_id: current_protector.id)
  end

  def params_message_user
    params.require(:message).permit(:user_id, :content, :room_id).merge(user_id: current_user.id)
  end
end
