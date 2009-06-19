require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :login => "created",
      :name => "value for name",
      :password => "value for password",
      :password_confirmation => "value for password",
      :salt => "value for salt",
      :present => false,
      :admin => false,
      :persistence_token => "created",
      :perishable_token => "created",
      :single_access_token => "created"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
