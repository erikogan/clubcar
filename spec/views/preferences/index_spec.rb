require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/preferences/index" do
  include PreferencesHelper
  
  before(:each) do
    assigns[:mood] = @mood = stub_model(Mood, :id => 23)
    assigns[:user] = @user = stub_model(User, :id => 42)
    assigns[:restaurant] = @restaurant = stub_model(Restaurant, :id => 37)
    assigns[:vote] = @vote = stub_model(Vote, :id => 1)
    
    assigns[:preferences] = [
      stub_model(Preference,
        :new_record? => false,
        :mood_id => @mood.id,
        :mood => @mood,
        :restaurant_id => @restaurant.id,
        :restaurant => @restaurant,
        :vote_id => @vote.id,
        :vote => @vote
      ),
      stub_model(Preference,
        :new_record? => false,
        :mood_id => @mood.id,
        :mood => @mood,
        :restaurant_id => @restaurant.id,
        :restaurant => @restaurant,
        :vote_id => @vote.id,
        :vote => @vote
      )
    ]
  end

  it "should render list of preferences" do
    render "/preferences/index"
  end
end

