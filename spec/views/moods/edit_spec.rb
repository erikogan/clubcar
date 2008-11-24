require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/moods/edit" do
  include MoodsHelper
  
  before(:each) do
    assigns[:user] = @user = stub_model(User, :id => 1)
    assigns[:mood] = @mood = stub_model(Mood,
      :new_record? => false,
      :user_id => @user.id,
      :name => "value for name",
      :active => true,
      :order => "1"
    )
  end

  it "should render edit form" do
    render "/moods/edit"
    
    response.should have_tag("form[action=#{user_mood_path(@user, @mood)}][method=post]") do
      with_tag('input#mood_name[name=?]', "mood[name]")
      with_tag('select#mood_active[name=?]', "mood[active]")
      with_tag('input#mood_order[name=?]', "mood[order]")
    end
  end
end


