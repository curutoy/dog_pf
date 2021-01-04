class MessagesController < ApplicationController
  before_action :authenticate_any!

  def create
    if protector_signed_in?
      @message = Message.new(params_message_protector)
      @room = @message.room
      if @message.save
        @entryroom = Entry.find_by(room_id: @room.id)
        notification = current_protector.active_notifications.new(
          room_id: @room.id,
          message_id: @message.id,
          visited_user_id: @theid.user_id,
          visited_protector_id: @theid.protector_id,
          visitor_protector_id: current_protector.id,
          action: 'dm'
        )
        if notification.visitor_protector_id == notification.visited_protector_id
          notification.checked = true
        end
        notification.save if notification.valid?
        redirect_to room_path(@message.room_id)
      else
        flash[:alert] = "メッセージ送信に失敗しました"
        redirect_to room_path(@message.room_id)
      end
    else
      @message = Message.new(params_message_user)
      @room = @message.room
      if @message.save
        @entryroom = Entry.find_by(room_id: @room.id)
        notification = current_user.active_notifications.new(
          room_id: @room.id,
          message_id: @message.id,
          visited_protector_id: @theid.protector_id,
          visited_user_id: @theid.user_id,
          visitor_user_id: current_user.id,
          action: 'dm'
        )
        if notification.visitor_user_id == notification.visited_user_id
          notification.checked = true
        end
        notification.save if notification.valid?
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
