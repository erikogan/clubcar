require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tag_types/index" do
  include TagTypesHelper
  
  before(:each) do
    assigns[:tag_types] = [
      stub_model(TagType,
        :name => "value for name"
      ),
      stub_model(TagType,
        :name => "value for name"
      )
    ]
  end

  it "should render list of tag_types" do
    render "/tag_types/index"
    response.should have_tag("tr>td", "value for name", 2)
  end
end

