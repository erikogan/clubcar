require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/emails/new" do
  include EmailsHelper
  
  before(:each) do
    assigns[:user] = @user = users(:erik)
    assigns[:email] = stub_model(Email,
      :new_record? => true,
      :address => "value for address",
      :user_id => @user.id
    )
  end

  it "should render new form" do
    render "/emails/new"
    
    response.should have_tag("form[action=?][method=post]", user_emails_path(@user)) do
      with_tag("input#email_address[name=?]", "email[address]")
    end
  end
end


