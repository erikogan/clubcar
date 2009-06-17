require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "responding to GET new" do
    # TODO slightly less useless
    it "should expose a new password_reset as @password_reset" do
      get :new
      response.should be_success
      response.should render_template('new')
    end

  end

  describe "responding to GET edit" do
  
    it "should confirm the magic ID and render the edit template" do
      ClubcarMailer.should_receive(:confirm_magic).with('fnord').and_return([user = mock_user, []])
      get :edit, :id => 'fnord'
      response.should be_success
      response.should render_template('edit')
      assigns[:user].should equal(user)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose the correct user as @user" do
        User.should_receive(:find_by_login_or_email).and_return(user = mock_user)
        post :create, :password_reset => {:these => 'params'}
        assigns(:user).should equal(user)
      end

      it "should redirect back to new" do
        User.should_receive(:find_by_login_or_email).and_return(user = mock_user)
        ClubcarMailer.should_receive(:create_forgotten_password).with(user).and_return(email = mock_model(TMail::Mail, {}))
        ClubcarMailer.should_receive(:deliver).with(email)
        post :create, :password_reset => {}
        response.should redirect_to(new_password_reset_path)
      end
      
    end
    
    describe "with invalid params" do

      it "should not find user" do
        User.should_receive(:find_by_login_or_email).and_return(nil)
        post :create, :password_reset => {:these => 'params'}
        assigns(:user).should equal(nil)
      end

      it "should re-render the 'new' template" do
        User.should_receive(:find_by_login_or_email).and_return(nil)
        post :create, :password_reset => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the user" do
        ClubcarMailer.should_receive(:confirm_magic).with('fnord').and_return([user = mock_user,[]])
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "fnord", :user => {:these => 'params'}
      end

      it "should redirect to the root" do
        ClubcarMailer.should_receive(:confirm_magic).with('fnord').and_return([user = mock_user,[]])
        mock_user.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
        mock_user.should_receive(:save).and_return(true)
        put :update, :id => "fnord", :user => {:these => 'params'}
        response.should redirect_to(root_url)
      end

    end
    
    describe "with invalid params" do

      it "should update the requested password_reset" do
        ClubcarMailer.should_receive(:confirm_magic).with('fnord').and_return([user = mock_user,["ERROR"]])
        put :update, :id => "fnord", :user => {:these => 'params'}
      end

      it "should expose the password_reset as @password_reset" do
        ClubcarMailer.should_receive(:confirm_magic).with('fnord').and_return([user = mock_user,["ERROR"]])
        put :update, :id => "fnord", :user => {:these => 'params'}
        assigns(:user).should equal(user)
      end

      it "should re-render the 'edit' template" do
        ClubcarMailer.should_receive(:confirm_magic).with('fnord').and_return([user = mock_user,["ERROR"]])
        put :update, :id => "fnord", :user => {:these => 'params'}
        response.should render_template('edit')
      end

    end

  end

end
