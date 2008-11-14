require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/votes/show" do
  include VotesHelper
  
  before(:each) do
    assigns[:vote] = @vote = stub_model(Vote,
      :name => "value for name",
      :value => "1",
      :genre_value => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/votes/show"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end

