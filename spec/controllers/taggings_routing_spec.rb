require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TaggingsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "taggings", :action => "index").should == "/taggings"
    end
  
    it "should map #new" do
      route_for(:controller => "taggings", :action => "new").should == "/taggings/new"
    end
  
    it "should map #show" do
      route_for(:controller => "taggings", :action => "show", :id => 1).should == "/taggings/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "taggings", :action => "edit", :id => 1).should == "/taggings/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "taggings", :action => "update", :id => 1).should == "/taggings/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "taggings", :action => "destroy", :id => 1).should == "/taggings/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/taggings").should == {:controller => "taggings", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/taggings/new").should == {:controller => "taggings", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/taggings").should == {:controller => "taggings", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/taggings/1").should == {:controller => "taggings", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/taggings/1/edit").should == {:controller => "taggings", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/taggings/1").should == {:controller => "taggings", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/taggings/1").should == {:controller => "taggings", :action => "destroy", :id => "1"}
    end
  end
end
