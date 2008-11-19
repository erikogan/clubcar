require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/restaurants/index" do
  include RestaurantsHelper
  
  before(:each) do
    assigns[:restaurants] = [
      stub_model(Restaurant,
        :name => "value for name",
        :address => "value for address",
        :city => "value for city",
        :distance => "1.5",
        :url => "value for url",
        :image => "value for image"
      ),
      stub_model(Restaurant,
        :name => "value for name",
        :address => "value for address",
        :city => "value for city",
        :distance => "1.5",
        :url => "value for url",
        :image => "value for image"
      )
    ]
  end

  it "should render list of restaurants" do
    render "/restaurants/index"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for address", 2)
    response.should have_tag("tr>td", "value for city", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "value for url", 2)
  end
end

