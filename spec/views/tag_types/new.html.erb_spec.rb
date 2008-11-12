require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tag_types/new.html.erb" do
  include TagTypesHelper
  
  before(:each) do
    assigns[:tag_type] = stub_model(TagType,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "should render new form" do
    render "/tag_types/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", tag_types_path) do
      with_tag("input#tag_type_name[name=?]", "tag_type[name]")
    end
  end
end


