require 'spec_helper'

describe "admin/users/show" do
  before(:each) do
    @admin_user = assign(:admin_user, stub_model(Admin::User))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
