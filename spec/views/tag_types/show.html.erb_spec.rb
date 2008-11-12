require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tag_types/show.html.erb" do
  include TagTypesHelper
  
  before(:each) do
    assigns[:tag_type] = @tag_type = stub_model(TagType,
      :name => "value for name"
    )
  end

  it "should render attributes in <p>" do
    render "/tag_types/show.html.erb"
    response.should have_text(/value\ for\ name/)
  end
end

