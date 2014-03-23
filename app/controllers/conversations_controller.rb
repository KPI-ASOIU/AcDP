class ConversationsController < ApplicationController
  def create
    @conversation = Conversation.create(conversation_params)
    handle_errors
    members_ids = params[:receivers_ids].push(params[:sender_id])
    members = User.where(id: members_ids)
    @conversation.participants = members
    @conversation.messages.build({ body: params[:message][:body], author: current_user })

    if @conversation.save
      redirect_to "/conversations", notice: t('messages.notice.send')
    else
      # TODO
      # => errors translation and maybe another way to display
      handle_errors
      @conversation.destroy
      redirect_to :back
    end
  end

  def index
    @conversations = Conversation.find(current_user
      .subscriptions.pluck(:conversation_id))
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    (@conversation.subscriptions.find_by user: current_user).destroy
    @conversation.destroy if @conversation.subscriptions.empty?
    # TODO
    # => get rid of extra redirect with ajax
    redirect_to :back
  end

  private
  def conversation_params
    params.require(:conversation).permit(:subject)
  end

  def handle_errors
    if @conversation.errors.any? 
      # TODO
      # => is it needed to handle all errors, or just this messages is enough????
      flash[:error] = t('messages.notice.error_send')
    end
  end
end
