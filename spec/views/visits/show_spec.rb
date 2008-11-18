require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visits/show" do
  include VisitsHelper
  
  before(:each) do
    @now = Date.now
    assigns[:visit] = @visit = stub_model(Visit,
      :restaurant_id => restaurants(:hobees),
      :date => @now,
      :duration => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/visits/show"
    response.should have_text(/#{@now}/)
    response.should have_text(/1/)
  end
end

