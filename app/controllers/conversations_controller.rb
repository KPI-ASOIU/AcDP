class ConversationsController < ApplicationController
  def create
    @conversation = Conversation.new(conversation_params)
    # TODO 
    #   - think about doing save only once and not getting error with messages
    @conversation.save!

    participants = params[:participants_ids].split(" ")
      .map { |id| User.find(id.to_i) }
    @conversation.participants = participants
    @conversation.messages.build({ body: params[:message][:body], author: current_user })

    if @conversation.save
      redirect_to "/conversations", notice: t('messages.notice.send')
      # TODO else error message    
    end
  end

  def index
    @conversations = Conversation.find(current_user
      .subscriptions.pluck(:conversation_id))
  end

  private
  def conversation_params
    params.require(:conversation).permit(:subject)
  end
end
