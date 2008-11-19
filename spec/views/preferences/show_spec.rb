require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/preferences/show" do
  include PreferencesHelper
  
  before(:each) do
    assigns[:mood] = @mood = stub_model(Mood, :id => 23)
    assigns[:user] = @user = stub_model(User, :id => 42)
    assigns[:restaurant] = @restaurant = stub_model(Restaurant, :id => 37)
    assigns[:vote] = @vote = stub_model(Vote, :id => 1)
    assigns[:preference] = @preference = stub_model(Preference,
      :mood_id => @mood.id,
      :mood => @mood,
      :restaurant_id => @restaurant.id,
      :restaurant => @restaurant,
      :vote_id => @vote.id,
      :vote => @vote
    )
  end

  it "should render attributes in <p>" do
    render "/preferences/show"
  end
end

