require File.dirname(__FILE__) + '/../test_helper'
require 'emails_controller'

# Re-raise errors caught by the controller.
class EmailsController; def rescue_action(e) raise e end; end

class EmailsControllerTest < Test::Unit::TestCase
  fixtures :emails

  def setup
    @controller = EmailsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:emails)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_email
    old_count = Email.count
    post :create, :email => { }
    assert_equal old_count+1, Email.count
    
    assert_redirected_to email_path(assigns(:email))
  end

  def test_should_show_email
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_email
    put :update, :id => 1, :email => { }
    assert_redirected_to email_path(assigns(:email))
  end
  
  def test_should_destroy_email
    old_count = Email.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Email.count
    
    assert_redirected_to emails_path
  end
end
