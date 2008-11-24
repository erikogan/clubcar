require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/password_resets/new" do
  include PasswordResetsHelper
  
  it "should render new form" do
    render "/password_resets/new"
    
    response.should have_tag("form[action=?][method=post]", password_resets_path) do
    end
  end
end


