require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tags/edit" do
  include TagsHelper
  
  before(:each) do
    assigns[:tag] = @tag = stub_model(Tag,
      :new_record? => false,
      :name => "value for name",
      :canonical => "valueforname",
      :type_id => tag_types(:tag).id
    )
  end

  it "should render edit form" do
    render "/tags/edit"
    
    response.should have_tag("form[action=#{tag_path(@tag)}][method=post]") do
      with_tag('input#tag_name[name=?]', "tag[name]")
      # with_tag('input#tag_canonical[name=?]', "tag[canonical]")
    end
  end
end


