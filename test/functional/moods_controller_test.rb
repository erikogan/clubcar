require File.dirname(__FILE__) + '/../test_helper'
require 'moods_controller'

# Re-raise errors caught by the controller.
class MoodsController; def rescue_action(e) raise e end; end

class MoodsControllerTest < Test::Unit::TestCase
  fixtures :moods

  def setup
    @controller = MoodsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:moods)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_mood
    old_count = Mood.count
    post :create, :mood => { }
    assert_equal old_count+1, Mood.count
    
    assert_redirected_to mood_path(assigns(:mood))
  end

  def test_should_show_mood
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_mood
    put :update, :id => 1, :mood => { }
    assert_redirected_to mood_path(assigns(:mood))
  end
  
  def test_should_destroy_mood
    old_count = Mood.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Mood.count
    
    assert_redirected_to moods_path
  end
end
