require 'spec_helper'

describe "admin/users/index" do
  before(:each) do
    assign(:admin_users, [
      stub_model(Admin::User),
      stub_model(Admin::User)
    ])
  end

  it "renders a list of admin/users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
