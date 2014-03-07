class MessagesController < ApplicationController
	def index
    @conversation = Conversation.find(params[:conversation_id])
    @messages = @conversation.messages
    @conversation.subscriptions.where(user: current_user).first.update_attributes(unread_messages_count: 0)
  end

  def create
    @message = Message.new(message_params)
    @message.author = current_user
    @message.conversation = Conversation.find(params[:conversation_id])

    respond_to do |format|
      if @message.save
        format.js {}
      else
        # TODO error messages here
        format.js {}
      end
    end
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end
end
