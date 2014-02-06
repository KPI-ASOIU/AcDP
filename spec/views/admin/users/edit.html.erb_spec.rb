require 'spec_helper'

describe "admin/users/edit" do
  before(:each) do
    @admin_user = assign(:admin_user, stub_model(Admin::User))
  end

  it "renders the edit admin_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_user_path(@admin_user), "post" do
    end
  end
end
