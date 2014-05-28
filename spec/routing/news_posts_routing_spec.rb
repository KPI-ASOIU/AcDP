require "spec_helper"

describe NewsPostsController do
  describe "routing" do

    it "routes to #index" do
      get("/news_posts").should route_to("news_posts#index")
    end

    it "routes to #new" do
      get("/news_posts/new").should route_to("news_posts#new")
    end

    it "routes to #show" do
      get("/news_posts/1").should route_to("news_posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/news_posts/1/edit").should route_to("news_posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/news_posts").should route_to("news_posts#create")
    end

    it "routes to #update" do
      put("/news_posts/1").should route_to("news_posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/news_posts/1").should route_to("news_posts#destroy", :id => "1")
    end

  end
end
