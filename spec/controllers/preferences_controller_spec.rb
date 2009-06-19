require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PreferencesController do
  it_should_behave_like 'login'

  def mock_preference(stubs={})
    @mock_preference ||= mock_model(Preference, stubs)
  end
  
  def mock_mood(stubs={})
    @mock_mood ||= mock_model(Mood, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  def mock_array()
    @mock_array ||= mock("Array of Preferences")
  end
  
  def mock_array_moods()
    @mock_array_moods ||= mock("Array of Moods")
  end
  
  before do
    # Most of these require admin access for editing others. Need to move them into an /admin namespace
    login({}, {:admin => true})
    User.should_receive(:find).with("42").and_return(mock_user)
    mock_user.should_receive(:moods).and_return(mock_array_moods)
    mock_array_moods.should_receive(:find).with("23").and_return(mock_mood)
  end
  
  
  describe "responding to GET index" do

    it "should expose all preferences as @preferences" do
      mock_mood.should_receive(:preferences).and_return(mock_array)
      mock_array.should_receive(:find).with(:all, anything).and_return([mock_preference])
      get :index, :user_id => "42", :mood_id => "23"
      assigns[:preferences].should == [mock_preference]
    end

    describe "with mime type of xml" do
  
      it "should render all preferences as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_mood.should_receive(:preferences).and_return(mock_array)
        mock_array.should_receive(:find).with(:all, anything).and_return(preferences = mock("Array of Preferences"))
        preferences.should_receive(:to_xml).and_return("generated XML")
        get :index, :user_id => "42", :mood_id => "23"
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested preference as @preference" do
      mock_mood.should_receive(:preferences).and_return(mock_array)
      mock_array.should_receive(:find).with("37", anything).and_return(mock_preference)
      get :show, :user_id => "42", :mood_id => "23", :id => "37"
      assigns[:preference].should equal(mock_preference)
    end
    
    describe "with mime type of xml" do

      it "should render the requested preference as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_mood.should_receive(:preferences).and_return(mock_array)
        mock_array.should_receive(:find).with("37", anything).and_return(mock_preference)
        mock_preference.should_receive(:to_xml).and_return("generated XML")
        get :show, :user_id => "42", :mood_id => "23", :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new preference as @preference" do
      Preference.should_receive(:new).and_return(mock_preference)
      get :new, :user_id => "42", :mood_id => "23"
      assigns[:preference].should equal(mock_preference)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested preference as @preference" do
      mock_mood.should_receive(:preferences).and_return(mock_array)
      mock_array.should_receive(:find).with("37").and_return(mock_preference)
      get :edit, :user_id => "42", :mood_id => "23", :id => "37"
      assigns[:preference].should equal(mock_preference)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created preference as @preference" do
        Preference.should_receive(:new).with({'these' => 'params'}).and_return(mock_preference(:save => true))
        post :create, :user_id => "42", :mood_id => "23", :preference => {:these => 'params'}
        assigns(:preference).should equal(mock_preference)
      end

      it "should redirect to the created preference" do
        Preference.stub!(:new).and_return(mock_preference(:save => true))
        post :create, :user_id => "42", :mood_id => "23", :preference => {}
        response.should redirect_to(user_mood_preference_url(mock_user, mock_mood, mock_preference))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved preference as @preference" do
        Preference.stub!(:new).with({'these' => 'params'}).and_return(mock_preference(:save => false))
        post :create, :user_id => "42", :mood_id => "23", :preference => {:these => 'params'}
        assigns(:preference).should equal(mock_preference)
      end

      it "should re-render the 'new' template" do
        Preference.stub!(:new).and_return(mock_preference(:save => false))
        post :create, :user_id => "42", :mood_id => "23", :preference => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do
    before do
      mock_mood.should_receive(:preferences).and_return(mock_array)
    end

    describe "with valid params" do
      
      it "should update the requested preference" do
        mock_array.should_receive(:find).with("37").and_return(mock_preference)
        mock_preference.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user_id => "42", :mood_id => "23", :id => "37", :preference => {:these => 'params'}
      end

      it "should expose the requested preference as @preference" do
        mock_array.stub!(:find).and_return(mock_preference(:update_attributes => true))
        put :update, :user_id => "42", :mood_id => "23", :id => "1"
        assigns(:preference).should equal(mock_preference)
      end

      it "should redirect to the preference" do
        mock_array.stub!(:find).and_return(mock_preference(:update_attributes => true))
        put :update, :user_id => "42", :mood_id => "23", :id => "1"
        response.should redirect_to(user_mood_preference_url(mock_user, mock_mood, mock_preference))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested preference" do
        mock_array.should_receive(:find).with("37").and_return(mock_preference)
        mock_preference.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user_id => "42", :mood_id => "23", :id => "37", :preference => {:these => 'params'}
      end

      it "should expose the preference as @preference" do
        mock_array.stub!(:find).and_return(mock_preference(:update_attributes => false))
        put :update, :user_id => "42", :mood_id => "23", :id => "1"
        assigns(:preference).should equal(mock_preference)
      end

      it "should re-render the 'edit' template" do
        mock_array.stub!(:find).and_return(mock_preference(:update_attributes => false))
        put :update, :user_id => "42", :mood_id => "23", :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    before do
      mock_mood.should_receive(:preferences).and_return(mock_array)
    end
    
    it "should destroy the requested preference" do
      mock_array.should_receive(:find).with("37").and_return(mock_preference)
      mock_preference.should_receive(:destroy)
      delete :destroy, :user_id => "42", :mood_id => "23", :id => "37"
    end
  
    it "should redirect to the preferences list" do
      mock_array.stub!(:find).and_return(mock_preference(:destroy => true))
      delete :destroy, :user_id => "42", :mood_id => "23", :id => "1"
      response.should redirect_to(user_mood_preferences_url(mock_user, mock_mood))
    end

  end

end
