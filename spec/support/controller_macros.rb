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
end
