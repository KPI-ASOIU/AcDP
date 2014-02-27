require 'spec_helper'

describe UsersController do

  describe "GET #show_current" do
    before :each do
      @user = FactoryGirl.create(:user, email: "troilk@lol.com")
      sign_in @user
    end

    it "page contains info about current user" do
      get :show_current
      assigns(:user).should eq(@user)
    end
    it "shows page of current user" do
      get :show_current
      response.should render_template :show_current
    end
  end

  describe "GET #edit_current" do
    before :each do
      @user = FactoryGirl.create(:user, email: "troilk@lol.com")
      sign_in @user
    end

    it "page for editing current user's info" do
      get :edit_current
      assigns(:user).should eq(@user)
    end
    it "shows edit page of current user" do
      get :edit_current
      response.should render_template :edit_current
    end
  end

  describe "PATCH #update_current" do
    before :each do
      @user = FactoryGirl.create(:user, email: "troilk@lol.com")
      sign_in @user
    end

    context "with valid params" do
      it "locates the requested @user" do
        patch :update_current, id: @user, user: FactoryGirl.attributes_for(:user)
        assigns(:user).should eq(@user)
      end

      it "changes @user's attributes" do
        patch :update_current, id: @user, \
            user: FactoryGirl.attributes_for(:user, email: "troilknewmail@lol.com", \
                                             avatar: fixture_file_upload(Rails.root.join('public/system/users/avatars/default/missing.png'), 'image/png'))
        @user.reload
        @user.email.should eq("troilknewmail@lol.com")
        @user.avatar_file_name.should eq("missing.png")
        @user.avatar.destroy
      end

      it "updates with empty password fields" do
        patch :update_current, id: @user, \
            user: FactoryGirl.attributes_for(:user, \
                                            email: "troilknewmail@lol.com", \
                                            password: "", \
                                            password_confirmation: "")
        @user.reload
        @user.email.should eq("troilknewmail@lol.com")
      end

      it "updates with right new password" do
        patch :update_current, id: @user, \
            user: FactoryGirl.attributes_for(:user, \
                                            email: "troilknewmail@lol.com", \
                                            password: "newpassword", \
                                            password_confirmation: "newpassword")
        @user.reload
        @user.email.should eq("troilknewmail@lol.com")
        @user.valid_password?("newpassword").should be_true
      end

      it "redirects to the updated user" do
        patch :update_current, id: @user, \
            user: FactoryGirl.attributes_for(:user)
        response.should redirect_to current_user_users_path
      end
    end

    context "with invalid params" do
      it "locates the requested @user" do
        patch :update_current, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        assigns(:user).should eq(@user)
      end

      it "does not change @user's attributes" do
        patch :update_current, id: @user, \
            user: FactoryGirl.attributes_for(:user, email: "ololo")
        @user.reload
        @user.email.should eq("troilk@lol.com")
      end

      it "does not update if one pass field is empty or wrong" do
        patch :update_current, id: @user, \
            user: FactoryGirl.attributes_for(:user, \
                                            login: "troilk", \
                                            email: "troilk@lol.com", \
                                            password: "newpassword", \
                                            password_confirmation: "")
        @user.reload
        @user.login.should_not eq("troilk")
        @user.valid_password?("newpassword").should be_false
      end

      it "re-renders edit method" do
        patch :update_current, id: @user, \
            user: FactoryGirl.attributes_for(:invalid_user)
        response.should render_template :edit_current
      end
    end
  end

  describe "DELETE users#avatar" do
    it "deletes avatar" do
      user = FactoryGirl.create(:user_with_avatar, email: "troilk@lol.com")
      sign_in user
      delete :avatar, id: user
      user.reload
      user.avatar_file_name.should eq(nil)
    end
  end
end
