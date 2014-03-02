class ConversationsController < ApplicationController
  def create
    @conversation = Conversation.new(conversation_params)
    @conversation.save

    participants = params[:participants_ids].split(" ")
      .map { |id| User.find(id.to_i) }

    @conversation.messages.build({ body: params[:message][:body], author: current_user })
    @conversation.participants = participants
    @conversation.save

    participants.each { |p| 
      @conversation.subscriptions.build({ user: p }) 
    }
  end

  private
  def conversation_params
    params.require(:conversation).permit(:subject)
  end
end
