module NotificationsHelper
  def notification_form(notification)
    if protector_signed_in?
      visitor = notification.visitor_user
      case notification.action
      when "follow"
        tag.a(visitor.name, href: user_path(visitor), style: "font-weight: bold;", class: "notification-follow") + "があなたをフォローしました"
      when "like"
        tag.a(visitor.name, href: user_path(visitor), style: "font-weight: bold;", class: "notification-like") + "が" +
          tag.a('保護犬', href: dog_path(notification.dog_id), style: "font-weight: bold;") + "をお気に入りに登録しました"
      when "dm"
        unless visitor.nil?
          tag.a(visitor.name, href: user_path(visitor), style: "font-weight: bold;") + "から" +
            tag.a('メッセージ', href: room_path(notification.room_id), style: "font-weight: bold;", class: "notification_message") + "が届いています"
        end
      end
    else
      visitor = notification.visitor_protector
      case notification.action
      when "dm"
        unless visitor.nil?
          tag.a(visitor.name, href: protector_path(visitor), style: "font-weight: bold;") + "から" +
            tag.a('メッセージ', href: room_path(notification.room_id), style: "font-weight: bold;", class: "notification_message") + "が届いています"
        end
      end
    end
  end

  def unchecked_notifications
    if protector_signed_in?
      current_protector.passive_notifications.where(checked: false)
    else
      current_user.passive_notifications.where(checked: false)
    end
  end
end
