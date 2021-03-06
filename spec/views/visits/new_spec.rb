require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visits/new" do
  include VisitsHelper
  
  before(:each) do
    assigns[:restaurant] = @restaurant = stub_model(Restaurant, :name => "Restaurant Name")
    assigns[:visit] = stub_model(Visit,
      :new_record? => true,
      :restaurant_id => restaurants(:hobees),
      :date => Time.now,
      :duration => "1"
    )
  end

  it "should render new form" do
    render "/visits/new"
    
    response.should have_tag("form[action=?][method=post]", restaurant_visits_path(@restaurant)) do
      with_tag("select#visit_date_1i[name=?]", "visit[date(1i)]")
      with_tag("input#visit_duration[name=?]", "visit[duration]")
    end
  end
end


