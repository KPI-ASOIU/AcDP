require 'spec_helper'

describe ConversationsController do
  include ControllerMacros

  describe "GET #index" do
    before(:each) do
      login_user_assign_current
    end

    it "assings @conversations" do
      conversation = FactoryGirl.create(:conversation, :subscript_users)
      @current_user.subscriptions.create(conversation: conversation)
      get :index
      expect(assigns(:conversations)).to eq([conversation])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST #create" do
    before(:all) do
      @conversation_attr = FactoryGirl.attributes_for(:conversation)
      @message_attr = FactoryGirl.attributes_for(:message)
      @message_invalid_attr = { body: "" }
    end

    before(:each) do
      login_user_assign_current
          @user = FactoryGirl.create(:user)
          @request.env["HTTP_REFERER"] = "http://#{request.host}/users/#{@user.id}"
      end

    context "with valid message attributes" do
      it "creates a new conversation" do
        expect{
          post :create, conversation: @conversation_attr, sender_id: @current_user.id, receiver_ids: [@user.id], modal_title: I18n.t('messages.new'), message: @message_attr
        }.to change(Conversation, :count).by(1)
      end

      it "builds and saves message" do
        expect{
          post :create, conversation: @conversation_attr, sender_id: @current_user.id, receiver_ids: [@user.id], modal_title: I18n.t('messages.new'), message: @message_attr
        }.to change(Message, :count).by(1)
      end

      it "redirects to conversations list" do
        post :create, conversation: @conversation_attr, sender_id: @current_user.id, receiver_ids: [@user.id], modal_title: I18n.t('messages.new'), message: @message_attr
        response.should redirect_to conversations_path
      end
    end

    context "with invalid message attributes" do
      it "doesn't save message" do
        expect{
          post :create, conversation: @conversation_attr, sender_id: @current_user.id, receiver_ids: [@user.id], modal_title: I18n.t('messages.new'), message: @message_invalid_attr
        }.to change(Message, :count).by(0)
      end

      it "displays errors and reload current page" do
        post :create, conversation: @conversation_attr, sender_id: @current_user.id, receiver_ids: [@user.id], modal_title: I18n.t('messages.new'), message: @message_invalid_attr
        flash[:error].should eq(I18n.t('messages.notice.error_send'))
        response.should redirect_to :back
      end

      it "doesn't save conversation" do
        expect{
          post :create, conversation: @conversation_attr, sender_id: @current_user.id, receiver_ids: [@user.id], modal_title: I18n.t('messages.new'), message: @message_invalid_attr
        }.to change(Conversation, :count).by(0)
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      login_user_assign_current
      @conversation = FactoryGirl.create(:conversation)
      @current_user.subscriptions.create(conversation: @conversation)
      @request.env["HTTP_REFERER"] = "http://#{request.host}/conversations"
    end

    it "destroys current user subscription to this conversation" do
      expect{
        delete :destroy, id: @conversation.id
      }.to change(@current_user.subscriptions, :count).by(-1)
    end

    context "conversation has no more subscriptions" do
      it "destroys conversation" do
        expect{
          delete :destroy, id: @conversation.id
        }.to change(Conversation, :count).by(-1)
      end
    end

    it "reloads current page" do
      delete :destroy, id: @conversation.id
      response.should redirect_to :back
    end
  end
end
