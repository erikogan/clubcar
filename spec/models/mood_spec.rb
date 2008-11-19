require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mood do
  before(:each) do
    @valid_attributes = {
      :user_id => users(:erik).id,
      :name => "value for name",
      :active => false,
      :order => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Mood.create!(@valid_attributes)
  end
end
