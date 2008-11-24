require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tags/show" do
  include TagsHelper
  
  before(:each) do
    assigns[:tag] = @tag = stub_model(Tag,
      :name => "value for name",
      :canonical => "valueforname",
      :type_id => tag_types(:tag).id
    )
  end

  it "should render attributes in <p>" do
    render "/tags/show"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/valueforname/)
  end
end

