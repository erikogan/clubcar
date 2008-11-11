require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/show.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:user] = @user = stub_model(User,
      :login => "value for login",
      :name => "value for name",
      :password => "value for password",
      :salt => "value for salt",
      :present => false,
      :admin => false
    )
  end

  it "should render attributes in <p>" do
    render "/users/show.html.erb"
    response.should have_text(/value\ for\ login/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ password/)
    response.should have_text(/value\ for\ salt/)
    response.should have_text(/als/)
    response.should have_text(/als/)
  end
end

