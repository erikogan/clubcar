require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VisitsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "visits", :restaurant_id => "42", :action => "index").should == "/restaurants/42/visits"
    end
  
    it "should map #new" do
      route_for(:controller => "visits", :restaurant_id => "42", :action => "new").should == "/restaurants/42/visits/new"
    end
  
    it "should map #show" do
      route_for(:controller => "visits", :restaurant_id => "42", :action => "show", :id => "1").should == "/restaurants/42/visits/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "visits", :restaurant_id => "42", :action => "edit", :id => "1").should == "/restaurants/42/visits/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "visits", :restaurant_id => "42", :action => "update", :id => "1").should == { :path => "/restaurants/42/visits/1", :method => "put" }
    end
  
    it "should map #destroy" do
      route_for(:controller => "visits", :restaurant_id => "42", :action => "destroy", :id => "1").should == { :path => "/restaurants/42/visits/1", :method => "delete" }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/restaurants/42/visits").should == {:controller => "visits", :restaurant_id => "42", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/restaurants/42/visits/new").should == {:controller => "visits", :restaurant_id => "42", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/restaurants/42/visits").should == {:controller => "visits", :restaurant_id => "42", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/restaurants/42/visits/1").should == {:controller => "visits", :restaurant_id => "42", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/restaurants/42/visits/1/edit").should == {:controller => "visits", :restaurant_id => "42", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/restaurants/42/visits/1").should == {:controller => "visits", :restaurant_id => "42", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/restaurants/42/visits/1").should == {:controller => "visits", :restaurant_id => "42", :action => "destroy", :id => "1"}
    end
  end
end
