require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/show" do
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
    @request.session[:user] = @user
    render "/users/show"
    response.should have_text(/value\ for\ login/)
    response.should have_text(/value\ for\ name/)
    # TODO: figure this out
    # response.should render_template('moods/_list')
  end
end

