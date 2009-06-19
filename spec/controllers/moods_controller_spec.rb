require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MoodsController do
  it_should_behave_like 'login'

  def mock_mood(stubs={})
    @mock_mood ||= mock_model(Mood, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  def mock_array()
    @mock_array ||= mock("Array of Moods")
  end
  
  before do
    # Most of these require admin access for editing others. Need to move them into an /admin namespace
    login({}, {:admin => true})
    User.should_receive(:find).with("42").and_return(mock_user)
  end

  after do
    assigns[:user].should equal(mock_user)
  end

  describe "responding to GET index" do
    before do
      mock_user.should_receive(:moods).and_return(mock_array)
      mock_array.should_receive(:sort).and_return(mock_array)
    end
    
    it "should expose all moods as @moods" do
      get :index, :user_id => "42"
      assigns[:moods].should == mock_array
    end

    describe "with mime type of xml" do
  
      it "should render all moods as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_array.should_receive(:to_xml).and_return("generated XML")
        get :index, :user_id => "42"
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do
    before do
      mock_user.should_receive(:moods).and_return(mock_array)
      mock_array.should_receive(:find).with("37").and_return(mock_mood)
    end

    it "should expose the requested mood as @mood" do
      get :show, :user_id => "42", :id => "37"
      assigns[:mood].should equal(mock_mood)
    end
    
    describe "with mime type of xml" do

      it "should render the requested mood as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_mood.should_receive(:to_xml).and_return("generated XML")
        get :show, :user_id => "42", :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new mood as @mood" do
      Mood.should_receive(:new).and_return(mock_mood)
      get :new, :user_id => "42"
      assigns[:mood].should equal(mock_mood)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested mood as @mood" do
      mock_user.should_receive(:moods).and_return(mock_array)
      mock_array.should_receive(:find).with("37").and_return(mock_mood)
      get :edit, :user_id => "42", :id => "37"
      assigns[:mood].should equal(mock_mood)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      before do
        mock_user.should_receive(:moods).and_return(mock_array)
        mock_array.should_receive(:<<).and_return(true)
      end
      
      it "should expose a newly created mood as @mood" do
        Mood.should_receive(:new).with({'these' => 'params'}).and_return(mock_mood(:save => true))
        post :create, :user_id => "42", :mood => {:these => 'params'}
        assigns(:mood).should equal(mock_mood)
      end

      it "should redirect to the created mood" do
        Mood.stub!(:new).and_return(mock_mood(:save => true))
        post :create, :user_id => "42", :mood => {}
        response.should redirect_to(change_user_mood_preferences_url(mock_user, mock_mood))
      end
      
    end
    
    describe "with invalid params" do
      before do
        mock_user.should_receive(:moods).and_return(mock_array)
        mock_array.should_receive(:<<).and_return(false)
      end

      it "should expose a newly created but unsaved mood as @mood" do
        Mood.stub!(:new).with({'these' => 'params'}).and_return(mock_mood(:save => false))
        post :create, :user_id => "42", :mood => {:these => 'params'}
        assigns(:mood).should equal(mock_mood)
      end

      it "should re-render the 'new' template" do
        Mood.stub!(:new).and_return(mock_mood(:save => false))
        post :create, :user_id => "42", :mood => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do
      before do
        mock_user.should_receive(:moods).and_return(mock_array)
      end

      it "should update the requested mood" do
        mock_array.should_receive(:find).with("37").and_return(mock_mood)
        mock_mood.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user_id => "42", :id => "37", :mood => {:these => 'params'}
      end

      it "should expose the requested mood as @mood" do
        mock_array.should_receive(:find).with("1").and_return(mock_mood)
        mock_mood.should_receive(:update_attributes)
        put :update, :user_id => "42", :id => "1", :mood => {}
        assigns(:mood).should equal(mock_mood)
      end

      it "should redirect to the mood" do
        mock_array.should_receive(:find).with("1").and_return(mock_mood)
        mock_mood.should_receive(:update_attributes).and_return(true)
        put :update, :user_id => "42", :id => "1", :mood => {}
        response.should redirect_to(user_mood_url(mock_user, mock_mood))
      end

    end
    
    describe "with invalid params" do
      before do
        mock_user.should_receive(:moods).and_return(mock_array)
      end

      it "should update the requested mood" do
        mock_array.should_receive(:find).with("37").and_return(mock_mood)
        mock_mood.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user_id => "42", :id => "37", :mood => {:these => 'params'}
      end

      it "should expose the mood as @mood" do
        mock_array.should_receive(:find).with("1").and_return(mock_mood)
        mock_mood.should_receive(:update_attributes)
        put :update, :user_id => "42", :id => "1", :mood => {}
        assigns(:mood).should equal(mock_mood)
      end

      it "should re-render the 'edit' template" do
        mock_array.should_receive(:find).with("1").and_return(mock_mood)
        mock_mood.should_receive(:update_attributes).and_return(false)
        put :update, :user_id => "42", :id => "1", :mood => {}
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    before do
      mock_user.should_receive(:moods).at_least(:once).and_return(mock_array)
      mock_array.should_receive(:find).with(37).and_return(mock_mood)
      mock_array.should_receive(:delete).with(mock_mood)
      mock_mood.should_receive(:destroy)
    end

    it "should destroy the requested mood" do
      delete :destroy, :user_id => "42", :id => "37"
    end
  
    it "should redirect to the moods list" do
      pending "The controller treats this as JS. Need to figure out why"
      delete :destroy, :user_id => "42", :id => "37"
      response.should redirect_to(user_moods_url(mock_user))
    end

  end

end
