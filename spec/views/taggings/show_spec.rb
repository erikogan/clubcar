require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/taggings/show" do
  #include TaggingsHelper
  
  before(:each) do
    assigns[:tagging] = @tagging = stub_model(Tagging,
      :taggable_type => "Restaurant",
      :tagger_type => "User",
      :context => "value for context"
    )
  end

  it "should render attributes in <p>" do
    render "/taggings/show"
    response.should have_text(/Restaurant/)
    response.should have_text(/User/)
    response.should have_text(/value\ for\ context/)
  end
end

