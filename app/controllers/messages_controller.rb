# TODO
# => messages aren't really instant - we must fix it

class MessagesController < ApplicationController
  before_action :load_conversation, only: [:index, :create]

	def index
    @messages = @conversation.messages
    begin
      (@conversation.subscriptions.find_by user: current_user).update_attribute(:unread_messages_count, 0)
    rescue
      flash[:error] = I18n.t('util.access_denied')
      redirect_to conversations_path
    end
  end

  def create
    @message = @conversation.messages.build(message_params)

    respond_to do |format|
      if @message.save
        format.html
        format.js
      else
        format.json { render json: @message.errors.full_messages }
      end
    end
  end

  private
  def message_params
    params.require(:message).permit(:body).merge(author: current_user)
  end

  def load_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
