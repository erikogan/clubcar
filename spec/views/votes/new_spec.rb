require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/votes/new" do
  include VotesHelper
  
  before(:each) do
    assigns[:vote] = stub_model(Vote,
      :new_record? => true,
      :name => "value for name",
      :value => "1",
      :genre_value => "1"
    )
  end

  it "should render new form" do
    render "/votes/new"
    
    response.should have_tag("form[action=?][method=post]", votes_path) do
      with_tag("input#vote_name[name=?]", "vote[name]")
      with_tag("input#vote_value[name=?]", "vote[value]")
      with_tag("input#vote_genre_value[name=?]", "vote[genre_value]")
    end
  end
end


