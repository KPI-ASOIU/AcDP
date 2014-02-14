require 'spec_helper'

describe Admin::UsersController do
  describe "UserTests" do
    login_user

    describe "GET #index" do
      shows_error_and_redirects_to_root_from :index, nil
    end

    describe "GET #show" do
      shows_error_and_redirects_to_root_from :index, FactoryGirl.create(:user)
    end

    describe "GET #new" do
      shows_error_and_redirects_to_root_from :new, nil
    end

    describe "POST #create" do
      it "does not create a new User" do
        expect {
          post :create, :user => FactoryGirl.attributes_for(:user)
        }.to change(User, :count).by(0)
      end
      it "displays error message and redirects to root" do
        post :create, :user => FactoryGirl.attributes_for(:user)
        flash[:error].should == I18n.t('util.access_denied')
        response.should redirect_to root_path
      end
    end

    describe "PUT #update" do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "does not change @user's attributes" do
        put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user, login: "troilk", email: "olo@lo.com", password: "newpassword", \
                                            password_confirmation: "newpassword")
        @user.reload
        @user.login.should_not eq("troilk")
        @user.email.should_not eq("olo@lo.com")
        @user.valid_password?("newpassword").should_not be_true
      end
      it "displays error message and redirects to root" do
        put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user, login: "troilk", email: "olo@lo.com", password: "newpassword", \
                                            password_confirmation: "newpassword")
        flash[:error].should == I18n.t('util.access_denied')
        response.should redirect_to root_path
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "does not delete the user" do
        expect{
          delete :destroy, id: @user
        }.to change(User,:count).by(0)
      end
      it "displays error message and redirects to root" do
        delete :destroy, id: @user
        flash[:error].should == I18n.t('util.access_denied')
        response.should redirect_to root_path
      end
    end
  end

  describe "AdminTests" do
    login_admin

    describe "GET #index" do
      it "assigns all users as @users" do
        user = FactoryGirl.create(:user)
        get :index
        assigns(:users).should eq(User.page "1")
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end

    describe "GET #show" do
      it "assigns the requested user to @user" do
        user = FactoryGirl.create(:user)
        get :show, id: user
        assigns(:user).should eq(user)
      end

      it "renders the #show view" do
        get :show, id: FactoryGirl.create(:user)
        response.should render_template :show
      end
    end

    describe "GET #new" do
      it "assigns a new user as @user" do
        get :new
        assigns(:user).should be_a_new(User)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new User" do
          expect {
            post :create, :user => FactoryGirl.attributes_for(:user)
          }.to change(User, :count).by(1)
        end

        it "assigns a newly created user as @user" do
          post :create, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should be_a(User)
          assigns(:user).should be_persisted
        end

        it "redirects to the new user" do
          post :create, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to admin_user_path(User.last)
        end
      end

      context "with invalid params" do
        it "does not save the new user" do
          expect{
            post :create, user: FactoryGirl.attributes_for(:invalid_user)
          }.to_not change(User,:count)
        end

        it "re-renders the new method" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          response.should render_template :new
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @user = FactoryGirl.create(:user, email: "good@dog.com")
      end

      context "with valid params" do
        it "locates the requested @user" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should eq(@user)
        end

        it "changes @user's attributes" do
          put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user, login: "misha", email: "olo@lo.com")
          @user.reload
          @user.login.should eq("misha")
          @user.email.should eq("olo@lo.com")
        end

        it "updates with empty password fields" do
          put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user, \
                                            login: "misha", \
                                            email: "olo@lo.com", \
                                            password: "", \
                                            password_confirmation: "")
          @user.reload
          @user.login.should eq("misha")
          @user.email.should eq("olo@lo.com")
        end

        it "updates with right new password" do
          put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user, \
                                            login: "misha", \
                                            email: "olo@lo.com", \
                                            password: "newpassword", \
                                            password_confirmation: "newpassword")
          @user.reload
          @user.login.should eq("misha")
          @user.valid_password?("newpassword").should be_true
        end

        it "redirects to the updated user" do
          put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user)
          response.should redirect_to admin_user_path(@user)
        end
      end

      context "with invalid params" do
        it "locates the requested @user" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
          assigns(:user).should eq(@user)
        end

        it "does not change @user's attributes" do
          put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user, email: "ololo")
          @user.reload
          @user.email.should eq("good@dog.com")
        end

        it "does not update if one pass field is empty or wrong" do
          put :update, id: @user, \
            user: FactoryGirl.attributes_for(:user, \
                                            login: "misha", \
                                            email: "olo@lo.com", \
                                            password: "", \
                                            password_confirmation: "newpassword")
          @user.reload
          @user.login.should_not eq("misha")
          @user.valid_password?("newpassword").should be_false
        end

        it "re-renders edit method" do
          put :update, id: @user, \
            user: FactoryGirl.attributes_for(:invalid_user)
          response.should render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "deletes the user" do
        expect{
          delete :destroy, id: @user
        }.to change(User,:count).by(-1)
      end

      it "redirects to users#index" do
        delete :destroy, id: @user
        response.should redirect_to admin_users_url
      end
    end
  end
end
