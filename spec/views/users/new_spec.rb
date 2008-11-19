require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/new" do
  include UsersHelper
  
  before(:each) do
    assigns[:user] = stub_model(User,
      :new_record? => true,
      :login => "value for login",
      :name => "value for name",
      :password => "value for password",
      :salt => "value for salt",
      :present => false,
      :admin => false
    )
  end

  it "should render new form" do
    render "/users/new"
    
    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_login[name=?]", "user[login]")
      with_tag("input#user_name[name=?]", "user[name]")
      with_tag("input#user_plain_password[name=?]", "user[plain_password]")
      with_tag("input#user_plain_password_confirmation[name=?]", "user[plain_password_confirmation]")
      #with_tag("input#user_present[name=?]", "user[present]")
      #with_tag("input#user_admin[name=?]", "user[admin]")
    end
  end
end


