require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/visits/edit" do
  include VisitsHelper
  
  before(:each) do
    assigns[:visit] = @visit = stub_model(Visit,
      :new_record? => false,
      :restaurant_id => restaurants(:hobees),
      :date => Date.now,
      :duration => "1"
    )
  end

  it "should render edit form" do
    render "/visits/edit"
    
    response.should have_tag("form[action=#{visit_path(@visit)}][method=post]") do
      with_tag('input#visit_date[name=?]', "visit[date]")
      with_tag('input#visit_duration[name=?]', "visit[duration]")
    end
  end
end


