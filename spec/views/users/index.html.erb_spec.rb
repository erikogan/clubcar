require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/index.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:users] = [
      stub_model(User,
        :login => "value for login",
        :name => "value for name",
        :password => "value for password",
        :salt => "value for salt",
        :present => false,
        :admin => false
      ),
      stub_model(User,
        :login => "value for login",
        :name => "value for name",
        :password => "value for password",
        :salt => "value for salt",
        :present => false,
        :admin => false
      )
    ]
  end

  it "should render list of users" do
    render "/users/index.html.erb"
    response.should have_tag("tr>td", "value for login", 2)
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for password", 2)
    response.should have_tag("tr>td", "value for salt", 2)
    response.should have_tag("tr>td", false, 2)
    response.should have_tag("tr>td", false, 2)
  end
end

