require 'spec_helper'

describe "news_posts/show" do
  before(:each) do
    @news_post = assign(:news_post, stub_model(NewsPost,
      :title => "Title",
      :text => "MyText",
      :tags => "Tags",
      :creator_id => 1,
      :for_roles => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/Tags/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
