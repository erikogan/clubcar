require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailsController do
  it_should_behave_like 'login'

  before do
    # Most of these require admin access. Need to move them into an /admin namespace
    log_in(users(:admin))
    User.should_receive(:find).with("1").and_return(mock_user({:id => 1}))
    @emails = mock("Array of Emails")
    Rails.logger.debug("M: #{mock_user.args_and_options.inspect}")
  end

  def mock_email(stubs={})
    @mock_email ||= mock_model(Email, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  describe "responding to GET index" do
    before do
      mock_user.should_receive(:emails).and_return(@emails)
      @emails.should_receive(:sort).and_return(@emails)
    end

    after do
      assigns[:emails].should == @emails
      response.should be_success
    end
    
    it "should expose all emails as @emails" do
      get :index, :user_id => 1
      response.should render_template("index")
    end

    describe "with mime type of xml" do
  
      it "should render all emails as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @emails.should_receive(:to_xml).and_return("generated XML")
        get :index, :user_id => 1
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do
    before do
      mock_user.should_receive(:emails).and_return(@emails)
      @emails.should_receive(:find).with("37").and_return(mock_email)
    end

    after do
      response.should be_success
      assigns[:email].should equal(mock_email)
    end

    it "should expose the requested email as @email" do
      get :show, :id => "37", :user_id => 1
      response.should render_template("show")
    end
    
    describe "with mime type of xml" do
      it "should render the requested email as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_email.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :user_id => 1
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET new" do
    it "should expose a new email as @email" do
      Email.should_receive(:new).and_return(mock_email)
      get :new, :user_id => 1
      response.should render_template("new")
      assigns[:email].should equal(mock_email)
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested email as @email" do
      mock_user.should_receive(:emails).and_return(@emails)
      @emails.should_receive(:find).with("37").and_return(mock_email)
      get :edit, :id => "37", :user_id => 1
      response.should render_template("edit")
      assigns[:email].should equal(mock_email)
    end
  end

  describe "responding to POST create" do
    before do
      mock_user.should_receive(:emails).and_return(@emails)
    end

    describe "with valid params" do
      before do
        @emails.should_receive(:<<).and_return(true)
      end

      it "should expose a newly created email as @email" do
        Email.should_receive(:new).with({"these" => 'params'}).and_return(mock_email(:save => true))
        post :create, :email => {:these => 'params'}, :user_id => 1
        assigns(:email).should equal(mock_email)
      end

      it "should redirect to the created email" do
        Email.stub!(:new).and_return(mock_email(:save => true))
        post :create, :email => {}, :user_id => 1
        Rails.logger.debug("WTF: #{response.inspect}")
        response.should redirect_to(user_email_url(mock_user, mock_email))
      end
      
    end
    
    describe "with invalid params" do
      before do
        @emails.should_receive(:<<).and_return(false)
      end
      it "should expose a newly created but unsaved email as @email" do
        Email.stub!(:new).with({'these' => 'params'}).and_return(mock_email(:save => false))
        post :create, :email => {:these => 'params'}, :user_id => 1
        assigns(:email).should equal(mock_email)
      end

      it "should re-render the 'new' template" do
        Email.stub!(:new).and_return(mock_email(:save => false))
        post :create, :email => {}, :user_id => 1
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    before do
      mock_user.should_receive(:emails).and_return(@emails)
      @emails.should_receive(:find).with("37").and_return(mock_email)
    end

    describe "with valid params" do
      it "should update the requested email" do
        mock_email.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user_id => 1, :email => {:these => 'params'}
      end

      it "should expose the requested email as @email" do
        @emails.stub!(:find).and_return(mock_email(:update_attributes => true))
        mock_email.should_receive(:update_attributes)
        put :update, :id => "37", :user_id => 1
        assigns(:email).should equal(mock_email)
      end

      it "should redirect to the email" do
        mock_email.should_receive(:update_attributes).and_return(true)
        put :update, :id => "37", :user_id => 1
        response.should redirect_to(user_email_url(mock_user,mock_email))
      end

    end
    
    describe "with invalid params" do
      it "should update the requested email" do
        mock_email.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user_id => 1, :email => {:these => 'params'}
      end

      it "should expose the email as @email" do
        mock_email.should_receive(:update_attributes)
        put :update, :id => "37", :user_id => 1
        assigns(:email).should equal(mock_email)
      end

      it "should re-render the 'edit' template" do
        mock_email.should_receive(:update_attributes)
        put :update, :id => "37", :user_id => 1
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    before do
      mock_user.should_receive(:emails).and_return(@emails)
      @emails.should_receive(:find).with("37").and_return(mock_email)
      mock_email.should_receive(:destroy)
    end

    it "should destroy the requested email" do
      delete :destroy, :id => "37", :user_id => 1
    end
  
    it "should redirect to the emails list" do
      delete :destroy, :id => "37", :user_id => 1
      response.should redirect_to(user_emails_url(mock_user))
    end
  end
end
