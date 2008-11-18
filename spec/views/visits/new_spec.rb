require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visits/new" do
  include VisitsHelper
  
  before(:each) do
    assigns[:visit] = stub_model(Visit,
      :new_record? => true,
      :restaurant_id => restaurants(:hobees),
      :date => Date.now,
      :duration => "1"
    )
  end

  it "should render new form" do
    render "/visits/new"
    
    response.should have_tag("form[action=?][method=post]", visits_path) do
      with_tag("input#visit_date[name=?]", "visit[date]")
      with_tag("input#visit_duration[name=?]", "visit[duration]")
    end
  end
end


