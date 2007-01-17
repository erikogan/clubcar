require File.dirname(__FILE__) + '/../test_helper'
require 'preferences_controller'

# Re-raise errors caught by the controller.
class PreferencesController; def rescue_action(e) raise e end; end

class PreferencesControllerTest < Test::Unit::TestCase
  fixtures :preferences

  def setup
    @controller = PreferencesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:preferences)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_preference
    old_count = Preference.count
    post :create, :preference => { }
    assert_equal old_count+1, Preference.count
    
    assert_redirected_to preference_path(assigns(:preference))
  end

  def test_should_show_preference
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_preference
    put :update, :id => 1, :preference => { }
    assert_redirected_to preference_path(assigns(:preference))
  end
  
  def test_should_destroy_preference
    old_count = Preference.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Preference.count
    
    assert_redirected_to preferences_path
  end
end
