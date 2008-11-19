require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/moods/new" do
  include MoodsHelper
  
  before(:each) do
    assigns[:user] = @user = stub_model(User, :id => 1)
    assigns[:mood] = stub_model(Mood,
      :new_record? => true,
      :name => "value for name",
      :active => false,
      :order => "1"
    )
  end

  it "should render new form" do
    render "/moods/new"
    
    response.should have_tag("form[action=?][method=post]", user_moods_path(@user)) do
      with_tag("input#mood_name[name=?]", "mood[name]")
      with_tag("select#mood_active[name=?]", "mood[active]")
      with_tag("input#mood_order[name=?]", "mood[order]")
    end
  end
end


