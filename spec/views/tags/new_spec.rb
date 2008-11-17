require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tags/new" do
  include TagsHelper
  
  before(:each) do
    assigns[:tag] = stub_model(Tag,
      :new_record? => true,
      :name => "value for name",
      :canonical => "valueforname",
      :type_id => tag_types(:tag).id
    )
  end

  it "should render new form" do
    render "/tags/new"
    
    response.should have_tag("form[action=?][method=post]", tags_path) do
      with_tag("input#tag_name[name=?]", "tag[name]")
    end
  end
end


