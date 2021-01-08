class NotificationsController < ApplicationController
  before_action :authenticate_any!

  def index
    if protector_signed_in?
      @notifications = current_protector.passive_notifications.includes({ visitor_user: [image_attachment: :blob] }, :dog).page(params[:page]).per(20).order('id DESC')
      @notifications.where(checked: false).each do |notification|
        notification.update_attributes(checked: true)
      end
    else
      @notifications = current_user.passive_notifications.includes({ visitor_protector: [image_attachment: :blob] }, :dog).page(params[:page]).per(20).order('id DESC')
      @notifications.where(checked: false).each do |notification|
        notification.update_attributes(checked: true)
      end
    end
  end
end
