require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TaggingsController do
  it_should_behave_like 'login'

  def mock_tagging(stubs={})
    @mock_tagging ||= mock_model(Tagging, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all taggings as @taggings" do
      Tagging.should_receive(:find).with(:all).and_return([mock_tagging])
      get :index
      assigns[:taggings].should == [mock_tagging]
    end

    describe "with mime type of xml" do
  
      it "should render all taggings as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tagging.should_receive(:find).with(:all).and_return(taggings = mock("Array of Taggings"))
        taggings.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested tagging as @tagging" do
      Tagging.should_receive(:find).with("37").and_return(mock_tagging)
      get :show, :id => "37"
      assigns[:tagging].should equal(mock_tagging)
    end
    
    describe "with mime type of xml" do

      it "should render the requested tagging as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tagging.should_receive(:find).with("37").and_return(mock_tagging)
        mock_tagging.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new tagging as @tagging" do
      Tagging.should_receive(:new).and_return(mock_tagging)
      get :new
      assigns[:tagging].should equal(mock_tagging)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested tagging as @tagging" do
      Tagging.should_receive(:find).with("37").and_return(mock_tagging)
      get :edit, :id => "37"
      assigns[:tagging].should equal(mock_tagging)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created tagging as @tagging" do
        Tagging.should_receive(:new).with({'these' => 'params'}).and_return(mock_tagging(:save => true))
        post :create, :tagging => {:these => 'params'}
        assigns(:tagging).should equal(mock_tagging)
      end

      it "should redirect to the created tagging" do
        Tagging.stub!(:new).and_return(mock_tagging(:save => true))
        post :create, :tagging => {}
        response.should redirect_to(tagging_url(mock_tagging))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved tagging as @tagging" do
        Tagging.stub!(:new).with({'these' => 'params'}).and_return(mock_tagging(:save => false))
        post :create, :tagging => {:these => 'params'}
        assigns(:tagging).should equal(mock_tagging)
      end

      it "should re-render the 'new' template" do
        Tagging.stub!(:new).and_return(mock_tagging(:save => false))
        post :create, :tagging => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested tagging" do
        Tagging.should_receive(:find).with("37").and_return(mock_tagging)
        mock_tagging.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tagging => {:these => 'params'}
      end

      it "should expose the requested tagging as @tagging" do
        Tagging.stub!(:find).and_return(mock_tagging(:update_attributes => true))
        put :update, :id => "1"
        assigns(:tagging).should equal(mock_tagging)
      end

      it "should redirect to the tagging" do
        Tagging.stub!(:find).and_return(mock_tagging(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(tagging_url(mock_tagging))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested tagging" do
        Tagging.should_receive(:find).with("37").and_return(mock_tagging)
        mock_tagging.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tagging => {:these => 'params'}
      end

      it "should expose the tagging as @tagging" do
        Tagging.stub!(:find).and_return(mock_tagging(:update_attributes => false))
        put :update, :id => "1"
        assigns(:tagging).should equal(mock_tagging)
      end

      it "should re-render the 'edit' template" do
        Tagging.stub!(:find).and_return(mock_tagging(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested tagging" do
      Tagging.should_receive(:find).with("37").and_return(mock_tagging)
      mock_tagging.should_receive(:taggable).and_return(mock("Mock Taggable"))
      mock_tagging.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the taggings list" do
      Tagging.stub!(:find).and_return(mock_tagging(:destroy => true))
      mock_tagging.should_receive(:taggable).and_return(mock("Mock Taggable"))
      delete :destroy, :id => "1"
      response.should redirect_to(taggings_url)
    end

  end

end
