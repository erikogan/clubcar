require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/taggings/new" do
  #include TaggingsHelper
  
  before(:each) do
    assigns[:tagging] = stub_model(Tagging,
      :new_record? => true,
      :taggable_type => "value for taggable_type",
      :tagger_type => "value for tagger_type",
      :context => "value for context"
    )
  end

  it "should render new form" do
    render "/taggings/new"
    
    response.should have_tag("form[action=?][method=post]", taggings_path) do
      with_tag("input#tagging_taggable_type[name=?]", "tagging[taggable_type]")
      with_tag("input#tagging_tagger_type[name=?]", "tagging[tagger_type]")
      with_tag("input#tagging_context[name=?]", "tagging[context]")
    end
  end
end


