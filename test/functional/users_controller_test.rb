require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # there's a bug in the TestSession class, :user isn't found
    @session    = { :user => users(:admin), 'user' => users(:admin) }
  end

  def test_should_get_index
    get :index, {}, @session
    assert_response :success
    assert assigns(:users)
  end

  def test_should_get_new
    get :new, {}, @session
    assert_response :success
  end
  
  def test_should_create_user
    old_count = User.count
    user = { 
      'name' => 'From Functional',
      'login' => 'func'
    }
    user['plain_password'] = user['plain_password_confirmation'] = 'foo'

    post :create, {:user => user}, @session

    assert_equal old_count+1, User.count
    
    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_show_user
    get :show, { :id => 1}, @session
    assert_response :success
  end

  def test_should_get_edit
    get :edit, { :id => 1 }, @session
    assert_response :success
  end
  
  def test_should_update_user
    put :update, { :id => 1, :user => { } }, @session
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_should_destroy_user
    old_count = User.count
    delete :destroy, { :id => 1 }, @session
    assert_equal old_count-1, User.count
    
    assert_redirected_to users_path
  end

  def test_should_logout
  end
end
