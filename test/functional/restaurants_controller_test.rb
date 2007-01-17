require File.dirname(__FILE__) + '/../test_helper'
require 'restaurants_controller'

# Re-raise errors caught by the controller.
class RestaurantsController; def rescue_action(e) raise e end; end

class RestaurantsControllerTest < Test::Unit::TestCase
  fixtures :restaurants

  def setup
    @controller = RestaurantsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:restaurants)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_restaurant
    old_count = Restaurant.count
    post :create, :restaurant => { }
    assert_equal old_count+1, Restaurant.count
    
    assert_redirected_to restaurant_path(assigns(:restaurant))
  end

  def test_should_show_restaurant
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_restaurant
    put :update, :id => 1, :restaurant => { }
    assert_redirected_to restaurant_path(assigns(:restaurant))
  end
  
  def test_should_destroy_restaurant
    old_count = Restaurant.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Restaurant.count
    
    assert_redirected_to restaurants_path
  end
end
