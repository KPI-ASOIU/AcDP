class NotificationController < WebsocketRails::BaseController
  def broadcast_new
    broadcast_message :new_issue, message, namespace: 'activity'
  end
end
