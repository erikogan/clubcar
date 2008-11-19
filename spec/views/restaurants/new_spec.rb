require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/restaurants/new" do
  include RestaurantsHelper
  
  before(:each) do
    assigns[:restaurant] = stub_model(Restaurant,
      :new_record? => true,
      :name => "value for name",
      :address => "value for address",
      :city => "value for city",
      :distance => "1.5",
      :url => "value for url",
      :image => "value for image"
    )
  end

  it "should render new form" do
    render "/restaurants/new"
    
    response.should have_tag("form[action=?][method=post]", restaurants_path) do
      with_tag("input#restaurant_name[name=?]", "restaurant[name]")
      with_tag("input#restaurant_address[name=?]", "restaurant[address]")
      with_tag("input#restaurant_city[name=?]", "restaurant[city]")
      with_tag("input#restaurant_distance[name=?]", "restaurant[distance]")
      with_tag("input#restaurant_url[name=?]", "restaurant[url]")
      with_tag("input#restaurant_image[name=?]", "restaurant[image]")
    end
  end
end


