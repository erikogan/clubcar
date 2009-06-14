require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/moods/index" do
  include MoodsHelper
  
  before(:each) do
    assigns[:user] = @user = stub_model(User, :id => 1)
    assigns[:moods] = [
      stub_model(Mood,
        :name => "value for name",
        :active => false,
        :order => "1"
      ),
      stub_model(Mood,
        :name => "value for name",
        :active => false,
        :order => "1"
      )
    ]
  end

  it "should render list of moods" do
    render "/moods/index"
    response.should have_tag("tr>td", "value for name", 2)
    # response.should have_tag("tr>td>img[src~checked]", false, 2)
    # response.should have_tag("tr>td", "1", 2)
  end
end

