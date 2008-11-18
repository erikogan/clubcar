require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/moods/show" do
  include MoodsHelper
  
  before(:each) do
    assigns[:user] = @user = stub_model(User, :id => 1)
    assigns[:mood] = @mood = stub_model(Mood,
      :name => "value for name",
      :active => false,
      :order => "112358"
    )
  end

  it "should render attributes in <p>" do
    render "/moods/show"
    response.should have_text(/value\ for\ name/)
    # response.should have_text(/als/)
    response.should have_text(/112358/)
  end
end

