require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tag_types/edit" do
  include TagTypesHelper
  
  before(:each) do
    assigns[:tag_type] = @tag_type = stub_model(TagType,
      :new_record? => false,
      :name => "value for name"
    )
  end

  it "should render edit form" do
    render "/tag_types/edit"
    
    response.should have_tag("form[action=#{tag_type_path(@tag_type)}][method=post]") do
      with_tag('input#tag_type_name[name=?]', "tag_type[name]")
    end
  end
end


