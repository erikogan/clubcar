require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSession do

  before(:each) do
    @valid_attributes = {
      :login => "erik",
      :password => "barfoo"
    }
  end

  it "should create a new instance given valid attributes" do
    pending "Activation. And testing Authlogic shouldn't be necessary"
    UserSession.create!(@valid_attributes)
  end
end
