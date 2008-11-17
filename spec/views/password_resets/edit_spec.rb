require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/password_resets/edit" do
  include PasswordResetsHelper
  
  before(:each) do
    assigns[:user] = @user = stub_model(User, :new_record? => false )
    assigns[:magic] = @magic = 'fnord'
    params[:id] = @magic
  end

  it "should render edit form" do
    render "/password_resets/edit"
    
    response.should have_tag("form[action=#{password_reset_path(@magic)}][method=post]") do
    end
  end
end


