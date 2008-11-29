require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tags/index" do
  include TagsHelper
  
  before(:each) do
    assigns[:tags] = [
      stub_model(Tag,
        :name => "value for name"
      ),
      stub_model(Tag,
        :name => "another value for name"
      )
    ]
  end

  it "should render list of tags" do
    render "/tags/index"
    response.should have_tag("tr>td", "value for name", 2)
    # response.should have_tag("tr>td", "value for canonical", 2)
  end
end

