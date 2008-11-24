require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visits/index" do
  include VisitsHelper
  
  before(:each) do
    assigns[:restaurant] = @restaurant = stub_model(Restaurant, :name => "Restaurant Name")
    @now = Time.now.to_date.to_s
    assigns[:visits] = [
      stub_model(Visit,
        :restaurant_id => restaurants(:hobees),
        :date => @now,
        :duration => "1"
      ),
      stub_model(Visit,
        :restaurant_id => restaurants(:hobees),
        :date => @now,
        :duration => "1"
      )
    ]
  end

  it "should render list of visits" do
    render "/visits/index"
    Rails.logger.debug("FOO: #{@now.to_date.to_s} | #{response.inspect}")
    response.should have_tag("tr>td", @now, 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

