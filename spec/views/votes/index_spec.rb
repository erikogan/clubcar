require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/votes/index" do
  include VotesHelper
  
  before(:each) do
    assigns[:votes] = [
      stub_model(Vote,
        :name => "value for name",
        :value => "1",
        :genre_value => "1"
      ),
      stub_model(Vote,
        :name => "value for name",
        :value => "1",
        :genre_value => "1"
      )
    ]
  end

  it "should render list of votes" do
    render "/votes/index"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

