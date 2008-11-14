require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/emails/index" do
  include EmailsHelper
  
  before(:each) do
    assigns[:user] = @user = users(:erik)
    assigns[:emails] = [
      stub_model(Email,
        :address => "value for address",
        :user_id => @user.id
      ),
      stub_model(Email,
        :address => "value for address",
        :user_id => @user.id
      )
    ]
  end

  it "should render list of emails" do
    render "/emails/index"
    response.should have_tag("tr>td", "value for address", 2)
  end
end

