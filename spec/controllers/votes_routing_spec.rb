require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VotesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "votes", :action => "index").should == "/votes"
    end
  
    it "should map #new" do
      route_for(:controller => "votes", :action => "new").should == "/votes/new"
    end
  
    it "should map #show" do
      route_for(:controller => "votes", :action => "show", :id => 1).should == "/votes/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "votes", :action => "edit", :id => 1).should == "/votes/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "votes", :action => "update", :id => 1).should == "/votes/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "votes", :action => "destroy", :id => 1).should == "/votes/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/votes").should == {:controller => "votes", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/votes/new").should == {:controller => "votes", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/votes").should == {:controller => "votes", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/votes/1").should == {:controller => "votes", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/votes/1/edit").should == {:controller => "votes", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/votes/1").should == {:controller => "votes", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/votes/1").should == {:controller => "votes", :action => "destroy", :id => "1"}
    end
  end
end
