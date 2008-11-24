require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visits/edit" do
  include VisitsHelper
  
  before(:each) do
    assigns[:restaurant] = @restaurant = stub_model(Restaurant, :name => "Restaurant Name")
    assigns[:visit] = @visit = stub_model(Visit,
      :new_record? => false,
      :restaurant_id => restaurants(:hobees).id,
      :date => Time.now,
      :duration => "1"
    )
  end

  it "should render edit form" do
    render "/visits/edit"
    
    response.should have_tag("form[action=#{restaurant_visit_path(@restaurant, @visit)}][method=post]") do
      with_tag("select#visit_date_1i[name=?]", "visit[date(1i)]")
      with_tag('input#visit_duration[name=?]', "visit[duration]")
    end
  end
end


