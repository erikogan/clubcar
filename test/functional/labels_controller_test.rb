require File.dirname(__FILE__) + '/../test_helper'
require 'labels_controller'

# Re-raise errors caught by the controller.
class LabelsController; def rescue_action(e) raise e end; end

class LabelsControllerTest < Test::Unit::TestCase
  fixtures :labels

  def setup
    @controller = LabelsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:labels)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_label
    old_count = Label.count
    post :create, :label => { }
    assert_equal old_count+1, Label.count
    
    assert_redirected_to label_path(assigns(:label))
  end

  def test_should_show_label
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_label
    put :update, :id => 1, :label => { }
    assert_redirected_to label_path(assigns(:label))
  end
  
  def test_should_destroy_label
    old_count = Label.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Label.count
    
    assert_redirected_to labels_path
  end
end
