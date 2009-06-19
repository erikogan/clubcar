require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PreferencesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "index").should == "/users/42/moods/23/preferences"
    end
  
    it "should map #new" do
      route_for(:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "new").should == "/users/42/moods/23/preferences/new"
    end
  
    it "should map #show" do
      route_for(:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "show", :id => "1").should == "/users/42/moods/23/preferences/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "edit", :id => "1").should == "/users/42/moods/23/preferences/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "update", :id => "1").should == { :path => "/users/42/moods/23/preferences/1", :method => "put" }
    end
  
    it "should map #destroy" do
      route_for(:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "destroy", :id => "1").should == { :path => "/users/42/moods/23/preferences/1", :method => "delete" }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/users/42/moods/23/preferences").should == {:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/users/42/moods/23/preferences/new").should == {:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/users/42/moods/23/preferences").should == {:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/users/42/moods/23/preferences/1").should == {:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/users/42/moods/23/preferences/1/edit").should == {:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/users/42/moods/23/preferences/1").should == {:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/users/42/moods/23/preferences/1").should == {:controller => "preferences", :user_id => "42", :mood_id => "23", :action => "destroy", :id => "1"}
    end
  end
end
