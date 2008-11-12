require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restaurant do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :address => "value for address",
      :city => "value for city",
      :distance => "1.5",
      :url => "value for url",
      :image => "value for image"
    }
        
  end

  it "should create a new instance given valid attributes" do
    Restaurant.create!(@valid_attributes)
  end
end
