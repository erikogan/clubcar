require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/user_sessions/new.html.erb" do
  include UserSessionsHelper
  
  before(:each) do
    assigns[:user_session] = stub_model(UserSession,
      :new_record? => true,
      :login => "value for login",
      :password => "value for password"
    )
  end

  it "renders new user_session form" do
    render
    
    response.should have_tag("form[action=?][method=post]", user_sessions_path) do
      with_tag("input#user_session_login[name=?]", "user_session[login]")
      with_tag("input#user_session_password[name=?]", "user_session[password]")
    end
  end
end


