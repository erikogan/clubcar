require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  # should it really?
  it_should_behave_like 'login'

  def mock_user_session(stubs={})
    @mock_user_session ||= mock_model(UserSession, stubs)
  end

  describe "GET new" do
    it "assigns a new user_session as @user_session" do
      UserSession.stub!(:new).and_return(mock_user_session)
      get :new
      assigns[:user_session].should equal(mock_user_session)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created user_session as @user_session" do
        UserSession.stub!(:new).with({'these' => 'params'}).and_return(mock_user_session(:save => true))
        post :create, :user_session => {:these => 'params'}
        assigns[:user_session].should equal(mock_user_session)
      end

      it "redirects to the root" do
        UserSession.stub!(:new).and_return(mock_user_session(:save => true))
        post :create, :user_session => {}
        response.should redirect_to(root_url)
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved user_session as @user_session" do
        UserSession.stub!(:new).with({'these' => 'params'}).and_return(mock_user_session(:save => false))
        post :create, :user_session => {:these => 'params'}
        assigns[:user_session].should equal(mock_user_session)
      end

      it "re-renders the 'new' template" do
        UserSession.stub!(:new).and_return(mock_user_session(:save => false))
        post :create, :user_session => {}
        response.should render_template('new')
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user_session" do
      UserSession.should_receive(:find).with("37").and_return(mock_user_session)
      mock_user_session.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the root" do
      UserSession.stub!(:find).and_return(mock_user_session(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(root_url)
    end
  end
end
