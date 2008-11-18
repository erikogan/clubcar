require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Visit do
  before(:each) do
    @valid_attributes = {
      :restaurant_id => restaurants(:hobees).id,
      :date => Time.now,
      :duration => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Visit.create!(@valid_attributes)
  end
end
