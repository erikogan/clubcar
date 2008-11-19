require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/preferences/new" do
  include PreferencesHelper
  
  before(:each) do
    assigns[:mood] = @mood = stub_model(Mood, :id => 23)
    assigns[:user] = @user = stub_model(User, :id => 42)
    assigns[:restaurant] = @restaurant = stub_model(Restaurant, :id => 37)
    assigns[:vote] = @vote = stub_model(Vote, :id => 1)
    assigns[:preference] = @preference = stub_model(Preference,
      :new_record? => true,
      :mood_id => @mood.id,
      :restaurant_id => @restaurant.id,
      :vote_id => @vote.id
    )
  end

  #it "should render new form" do
  #  pending "I removed this template"
  #  render "/preferences/new"
  #  
  #  response.should have_tag("form[action=?][method=post]", user_mood_preferences_path) do
  #  end
  #end
end


