require 'spec_helper'

describe "news_posts/index" do
  before(:each) do
    assign(:news_posts, [
      stub_model(NewsPost,
        :title => "Title",
        :text => "MyText",
        :tags => "Tags",
        :creator_id => 1,
        :for_roles => 2
      ),
      stub_model(NewsPost,
        :title => "Title",
        :text => "MyText",
        :tags => "Tags",
        :creator_id => 1,
        :for_roles => 2
      )
    ])
  end

  it "renders a list of news_posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Tags".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
