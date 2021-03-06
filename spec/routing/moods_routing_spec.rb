require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MoodsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "moods", :user_id => "1", :action => "index").should == "/users/1/moods"
    end
  
    it "should map #new" do
      route_for(:controller => "moods", :user_id => "1", :action => "new").should == "/users/1/moods/new"
    end
  
    it "should map #show" do
      route_for(:controller => "moods", :user_id => "1", :action => "show", :id => "1").should == "/users/1/moods/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "moods", :user_id => "1", :action => "edit", :id => "1").should == "/users/1/moods/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "moods", :user_id => "1", :action => "update", :id => "1").should == { :path => "/users/1/moods/1", :method => "put" }
    end
  
    it "should map #destroy" do
      route_for(:controller => "moods", :user_id => "1", :action => "destroy", :id => "1").should == { :path => "/users/1/moods/1", :method => "delete" }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/users/1/moods").should == {:controller => "moods", :user_id => "1", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/users/1/moods/new").should == {:controller => "moods", :user_id => "1", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/users/1/moods").should == {:controller => "moods", :user_id => "1", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/users/1/moods/1").should == {:controller => "moods", :user_id => "1", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/users/1/moods/1/edit").should == {:controller => "moods", :user_id => "1", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/users/1/moods/1").should == {:controller => "moods", :user_id => "1", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/users/1/moods/1").should == {:controller => "moods", :user_id => "1", :action => "destroy", :id => "1"}
    end
  end
end
