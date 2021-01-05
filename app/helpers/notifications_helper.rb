module NotificationsHelper
  def notification_form(notification)
    if protector_signed_in?
      visitor = notification.visitor_user
      case notification.action
      when "follow"
        tag.a(visitor.name, href: user_path(visitor), style: "font-weight: bold;") + "があなたをフォローしました"
      when "like"
        tag.a(visitor.name, href: user_path(visitor), style: "font-weight: bold;") + "が" +
          tag.a('保護犬', href: dog_path(notification.dog_id), style: "font-weight: bold;") + "をお気に入りに登録しました"
      when "dm"
        unless visitor.nil?
          tag.a(visitor.name, href: user_path(visitor), style: "font-weight: bold;") + "から" +
            tag.a('メッセージ', href: room_path(notification.room_id), style: "font-weight: bold;") + "が届いています"
        end
      end
    else
      visitor = notification.visitor_protector
      case notification.action
      when "dm"
        unless visitor.nil?
          tag.a(visitor.name, href: user_path(visitor), style: "font-weight: bold;") + "から" +
            tag.a('メッセージ', href: room_path(notification.room_id), style: "font-weight: bold;") + "が届いています"
        end
      end
    end
  end
end
