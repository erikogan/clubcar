require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/edit.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:user] = @user = stub_model(User,
      :new_record? => false,
      :login => "value for login",
      :name => "value for name",
      :password => "value for password",
      :salt => "value for salt",
      :present => false,
      :admin => false
    )
  end

  it "should render edit form" do
    render "/users/edit.html.erb"
    
    response.should have_tag("form[action=#{user_path(@user)}][method=post]") do
      with_tag('input#user_login[name=?]', "user[login]")
      with_tag('input#user_name[name=?]', "user[name]")
      with_tag('input#user_password[name=?]', "user[password]")
      with_tag('input#user_salt[name=?]', "user[salt]")
      with_tag('input#user_present[name=?]', "user[present]")
      with_tag('input#user_admin[name=?]', "user[admin]")
    end
  end
end


