require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VotesController do
  it_should_behave_like 'login'

  def mock_vote(stubs={})
    @mock_vote ||= mock_model(Vote, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all votes as @votes" do
      Vote.should_receive(:find).with(:all, :order=>"value DESC").and_return([mock_vote])
      get :index
      assigns[:votes].should == [mock_vote]
    end

    describe "with mime type of xml" do
  
      it "should render all votes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Vote.should_receive(:find).with(:all, :order=>"value DESC").and_return(votes = mock("Array of Votes"))
        votes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested vote as @vote" do
      Vote.should_receive(:find).with("37").and_return(mock_vote)
      get :show, :id => "37"
      assigns[:vote].should equal(mock_vote)
    end
    
    describe "with mime type of xml" do

      it "should render the requested vote as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Vote.should_receive(:find).with("37").and_return(mock_vote)
        mock_vote.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new vote as @vote" do
      Vote.should_receive(:new).and_return(mock_vote)
      get :new
      assigns[:vote].should equal(mock_vote)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested vote as @vote" do
      Vote.should_receive(:find).with("37").and_return(mock_vote)
      get :edit, :id => "37"
      assigns[:vote].should equal(mock_vote)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created vote as @vote" do
        Vote.should_receive(:new).with({'these' => 'params'}).and_return(mock_vote(:save => true))
        post :create, :vote => {:these => 'params'}
        assigns(:vote).should equal(mock_vote)
      end

      it "should redirect to the created vote" do
        Vote.stub!(:new).and_return(mock_vote(:save => true))
        post :create, :vote => {}
        response.should redirect_to(vote_url(mock_vote))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved vote as @vote" do
        Vote.stub!(:new).with({'these' => 'params'}).and_return(mock_vote(:save => false))
        post :create, :vote => {:these => 'params'}
        assigns(:vote).should equal(mock_vote)
      end

      it "should re-render the 'new' template" do
        Vote.stub!(:new).and_return(mock_vote(:save => false))
        post :create, :vote => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested vote" do
        Vote.should_receive(:find).with("37").and_return(mock_vote)
        mock_vote.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :vote => {:these => 'params'}
      end

      it "should expose the requested vote as @vote" do
        Vote.stub!(:find).and_return(mock_vote(:update_attributes => true))
        put :update, :id => "1"
        assigns(:vote).should equal(mock_vote)
      end

      it "should redirect to the vote" do
        Vote.stub!(:find).and_return(mock_vote(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(vote_url(mock_vote))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested vote" do
        Vote.should_receive(:find).with("37").and_return(mock_vote)
        mock_vote.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :vote => {:these => 'params'}
      end

      it "should expose the vote as @vote" do
        Vote.stub!(:find).and_return(mock_vote(:update_attributes => false))
        put :update, :id => "1"
        assigns(:vote).should equal(mock_vote)
      end

      it "should re-render the 'edit' template" do
        Vote.stub!(:find).and_return(mock_vote(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested vote" do
      Vote.should_receive(:find).with("37").and_return(mock_vote)
      mock_vote.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the votes list" do
      Vote.stub!(:find).and_return(mock_vote(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(votes_url)
    end

  end

end
