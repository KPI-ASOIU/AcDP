class MessageController < WebsocketRails::BaseController
  def broadcast_new
    puts message
    broadcast_message :new_message, message, namespace: 'messages'
  end
end
