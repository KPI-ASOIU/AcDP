require 'spec_helper'

describe MessagesController do
	include ControllerMacros

	before(:each) do
		login_user_assign_current
		@conversation = FactoryGirl.create(:conversation, :subscript_users)
		@conversation.participants << @current_user
		@conversation.messages.create({ body: "Hello", author: @conversation.participants[0] })
	end

	describe "GET #index" do
		it "assigns @messages" do
			get :index, conversation_id: @conversation.id
			expect(assigns(:messages)).to eq(@conversation.messages)
		end

		it "changes unread messages counter for this current user subscription to 0" do
			get :index, conversation_id: @conversation.id
			expect(@current_user.subscriptions.find_by(conversation: @conversation).unread_messages_count).to eq(0)
		end
	end

	describe "POST #create" do
		before(:each) do
			@params = { message: { body: "Hello", author: @current_user }, conversation_id: @conversation.id }
		end

		it "creates message" do
			expect{
				xhr :post, :create, @params
			}.to change(Message, :count).by(1)
		end

		it "renders template" do
			xhr :post, :create, @params
			expect(response).to render_template("create")
		end
	end
end
