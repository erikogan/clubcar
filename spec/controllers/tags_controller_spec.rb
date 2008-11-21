require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsController do
  it_should_behave_like 'login'

  def mock_tag(stubs={})
    @mock_tag ||= mock_model(Tag, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all tags as @tags" do
      Tag.should_receive(:find).with(:all).and_return([mock_tag])
      get :index
      assigns[:tags].should == [mock_tag]
    end

    describe "with mime type of xml" do
  
      it "should render all tags as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tag.should_receive(:find).with(:all).and_return(tags = mock("Array of Tags"))
        tags.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested tag as @tag" do
      Tag.should_receive(:find).with("37").and_return(mock_tag)
      get :show, :id => "37"
      assigns[:tag].should equal(mock_tag)
    end
    
    describe "with mime type of xml" do

      it "should render the requested tag as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tag.should_receive(:find).with("37").and_return(mock_tag)
        mock_tag.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new tag as @tag" do
      Tag.should_receive(:new).and_return(mock_tag)
      get :new
      assigns[:tag].should equal(mock_tag)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested tag as @tag" do
      Tag.should_receive(:find).with("37").and_return(mock_tag)
      get :edit, :id => "37"
      assigns[:tag].should equal(mock_tag)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created tag as @tag" do
        Tag.should_receive(:new).with({'these' => 'params'}).and_return(mock_tag(:save => true))
        post :create, :tag => {:these => 'params'}
        assigns(:tag).should equal(mock_tag)
      end

      it "should redirect to the created tag" do
        Tag.stub!(:new).and_return(mock_tag(:save => true))
        post :create, :tag => {}
        response.should redirect_to(tag_url(mock_tag))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved tag as @tag" do
        Tag.stub!(:new).with({'these' => 'params'}).and_return(mock_tag(:save => false))
        post :create, :tag => {:these => 'params'}
        assigns(:tag).should equal(mock_tag)
      end

      it "should re-render the 'new' template" do
        Tag.stub!(:new).and_return(mock_tag(:save => false))
        post :create, :tag => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested tag" do
        Tag.should_receive(:find).with("37").and_return(mock_tag)
        mock_tag.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tag => {:these => 'params'}
      end

      it "should expose the requested tag as @tag" do
        Tag.stub!(:find).and_return(mock_tag(:update_attributes => true))
        put :update, :id => "1"
        assigns(:tag).should equal(mock_tag)
      end

      it "should redirect to the tag" do
        Tag.stub!(:find).and_return(mock_tag(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(tag_url(mock_tag))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested tag" do
        Tag.should_receive(:find).with("37").and_return(mock_tag)
        mock_tag.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tag => {:these => 'params'}
      end

      it "should expose the tag as @tag" do
        Tag.stub!(:find).and_return(mock_tag(:update_attributes => false))
        put :update, :id => "1"
        assigns(:tag).should equal(mock_tag)
      end

      it "should re-render the 'edit' template" do
        Tag.stub!(:find).and_return(mock_tag(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested tag" do
      Tag.should_receive(:find).with("37").and_return(mock_tag)
      mock_tag.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the tags list" do
      Tag.stub!(:find).and_return(mock_tag(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(tags_url)
    end

  end

end
