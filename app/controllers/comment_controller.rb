class CommentController < WebsocketRails::BaseController
  def broadcast_new
    broadcast_message :new_comment, message, namespace: 'comments'
  end
end
