require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tagging do
  before(:each) do
    @valid_attributes = {
      :tag_id => tags(:crap).id,
      :taggable_id => restaurants(:fjl2).id,
      :taggable_type => "Restaurant",
      :tagger_id => users(:erik).id,
      :tagger_type => "User",
      :context => "tags",
      :created_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Tagging.create!(@valid_attributes)
  end
end
