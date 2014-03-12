module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user_admin)
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      sign_in user
    end
  end

  def shows_error_and_redirects_to_root_from(page, id)
    it "displays error message and redirects to root" do
      get page, id: id
      flash[:error].should == I18n.t('util.access_denied')
      response.should redirect_to root_path
    end
  end

  # PURPOSE:
  #   login user and get the @current_user variable for usage 
  #   in tests as analogue of current_user in controllers
  def login_user_assign_current
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end
end
