require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/taggings/edit" do
  #include TaggingsHelper
  
  before(:each) do
    assigns[:tagging] = @tagging = stub_model(Tagging,
      :new_record? => false,
      :taggable_id => 1,
      :taggable_type => "Restaurant",
      :tagger_id => 2,
      :tagger_type => "User",
      :context => "value for context",
      :tag_id => 3
    )
  end

  it "should render edit form" do
    render "/taggings/edit"
    
    response.should have_tag("form[action=#{tagging_path(@tagging)}][method=post]") do
      #with_tag('input#tagging_taggable_type[name=?, value=?]', "tagging[taggable_type]", "value for taggable_type")
      with_tag('input#tagging_taggable_type[name=?]', "tagging[taggable_type]")
      with_tag('input#tagging_tagger_type[name=?]', "tagging[tagger_type]")
      with_tag('input#tagging_context[name=?]', "tagging[context]")
    end
  end
end


