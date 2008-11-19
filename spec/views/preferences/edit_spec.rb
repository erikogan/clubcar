require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/preferences/edit" do
  include PreferencesHelper
  
  before(:each) do
    assigns[:mood] = @mood = stub_model(Mood, :id => 23)
    assigns[:user] = @user = stub_model(User, :id => 42)
    assigns[:restaurant] = @restaurant = stub_model(Restaurant, :id => 37)
    assigns[:vote] = @vote = stub_model(Vote, :id => 1)
    assigns[:preference] = @preference = stub_model(Preference,
      :new_record? => false,
      :mood_id => @mood.id,
      :mood => @mood,
      :restaurant_id => @restaurant.id,
      :restaurant => @restaurant,
      :vote_id => @vote.id,
      :vote => @vote
    )
    assigns[:preference_values] = [];
  end

  it "should render edit form" do
    render "/preferences/edit"
    
    response.should have_tag("form[action=#{user_mood_preference_path(@user, @mood, @preference)}][method=post]") do
    end
  end
end


