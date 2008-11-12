require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/restaurants/edit.html.erb" do
  include RestaurantsHelper
  
  before(:each) do
    assigns[:restaurant] = @restaurant = stub_model(Restaurant,
      :new_record? => false,
      :name => "value for name",
      :address => "value for address",
      :city => "value for city",
      :distance => "1.5",
      :url => "value for url",
      :image => "value for image"
    )
  end

  it "should render edit form" do
    render "/restaurants/edit.html.erb"
    
    response.should have_tag("form[action=#{restaurant_path(@restaurant)}][method=post]") do
      with_tag('input#restaurant_name[name=?]', "restaurant[name]")
      with_tag('input#restaurant_address[name=?]', "restaurant[address]")
      with_tag('input#restaurant_city[name=?]', "restaurant[city]")
      with_tag('input#restaurant_distance[name=?]', "restaurant[distance]")
      with_tag('input#restaurant_url[name=?]', "restaurant[url]")
      with_tag('input#restaurant_image[name=?]', "restaurant[image]")
    end
  end
end


