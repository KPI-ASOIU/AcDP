class ConversationsController < ApplicationController
  def create
    @conversation = Conversation.create(conversation_params)
    handle_errors
    params[:receiver_ids] ||= []
    members_ids = params[:receiver_ids].push(current_user.id)
    members = User.where(id: members_ids)
    @conversation.participants = members
    @conversation.messages.build({ body: params[:message][:body], author: current_user })

    if @conversation.save
      redirect_to conversations_path, notice: t('messages.notice.send')
    else
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
    redirect_to :back
  end

  private
  def conversation_params
    params.require(:conversation).permit(:subject)
  end

  def handle_errors
    if @conversation.errors.any?
      flash[:error] = t('messages.notice.error_send')
    end
  end
end
