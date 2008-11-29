require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/taggings/index" do
  #include TaggingsHelper
  
  before(:each) do
    assigns[:taggings] = [
      stub_model(Tagging,
        :taggable => mock("Mock Taggable"),
        :taggable_type => "value for taggable_type",
        :tagger => mock("Mock Tagger"),
        :tagger_type => "value for tagger_type",
        :context => "value for context",
        :created_at => Time.now
      ),
      stub_model(Tagging,
        :taggable => mock("Mock Taggable"),
        :taggable_type => "value for taggable_type",
        :tagger => mock("Mock Tagger"),
        :tagger_type => "value for tagger_type",
        :context => "value for context",
        :created_at => Time.now
      )
    ]
  end

  it "should render list of taggings" do
    render "/taggings/index"
    response.should have_tag("tr>td", "value for taggable_type", 2)
    response.should have_tag("tr>td", "value for tagger_type", 2)
    response.should have_tag("tr>td", "value for context", 2)
  end
end

