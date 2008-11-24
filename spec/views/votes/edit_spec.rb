require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/votes/edit" do
  include VotesHelper
  
  before(:each) do
    assigns[:vote] = @vote = stub_model(Vote,
      :new_record? => false,
      :name => "value for name",
      :value => "1",
      :genre_value => "1"
    )
  end

  it "should render edit form" do
    render "/votes/edit"
    
    response.should have_tag("form[action=#{vote_path(@vote)}][method=post]") do
      with_tag('input#vote_name[name=?]', "vote[name]")
      with_tag('input#vote_value[name=?]', "vote[value]")
      with_tag('input#vote_genre_value[name=?]', "vote[genre_value]")
    end
  end
end


