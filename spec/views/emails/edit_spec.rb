require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/1/emails/edit" do
  include EmailsHelper
  
  before(:each) do
    assigns[:user] = @user = users(:erik)
    assigns[:email] = @email = stub_model(Email,
      :new_record? => false,
      :address => "value for address",
      :user_id => @user.id
    )
  end

  it "should render edit form" do
    render "/emails/edit"
    
    response.should have_tag("form[action=#{user_email_path(@user, @email)}][method=post]") do
      with_tag('input#email_address[name=?]', "email[address]")
    end
  end
end


