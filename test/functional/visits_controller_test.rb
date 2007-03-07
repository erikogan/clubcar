require File.dirname(__FILE__) + '/../test_helper'
require 'visits_controller'

# Re-raise errors caught by the controller.
class VisitsController; def rescue_action(e) raise e end; end

class VisitsControllerTest < Test::Unit::TestCase
  fixtures :visits

  def setup
    @controller = VisitsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:visits)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_visit
    old_count = Visit.count
    post :create, :visit => { }
    assert_equal old_count+1, Visit.count
    
    assert_redirected_to visit_path(assigns(:visit))
  end

  def test_should_show_visit
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_visit
    put :update, :id => 1, :visit => { }
    assert_redirected_to visit_path(assigns(:visit))
  end
  
  def test_should_destroy_visit
    old_count = Visit.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Visit.count
    
    assert_redirected_to visits_path
  end
end
