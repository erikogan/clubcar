require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/restaurants/show" do
  include RestaurantsHelper
  
  before(:each) do
    assigns[:restaurant] = @restaurant = stub_model(Restaurant,
      :name => "value for name",
      :address => "value for address",
      :city => "value for city",
      :distance => "1.5",
      :url => "value for url",
      :image => "value for image"
    )
  end

  it "should render attributes in <p>" do
    render "/restaurants/show"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ address/)
    response.should have_text(/value\ for\ city/)
    response.should have_text(/1\.5/)
    response.should have_text(/value\ for\ url/)
    response.should have_text(/value\ for\ image/)
  end
end

