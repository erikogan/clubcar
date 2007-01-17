require File.dirname(__FILE__) + '/../test_helper'
require 'tag_types_controller'

# Re-raise errors caught by the controller.
class TagTypesController; def rescue_action(e) raise e end; end

class TagTypesControllerTest < Test::Unit::TestCase
  fixtures :tag_types

  def setup
    @controller = TagTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:tag_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_tag_type
    old_count = TagType.count
    post :create, :tag_type => { }
    assert_equal old_count+1, TagType.count
    
    assert_redirected_to tag_type_path(assigns(:tag_type))
  end

  def test_should_show_tag_type
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_tag_type
    put :update, :id => 1, :tag_type => { }
    assert_redirected_to tag_type_path(assigns(:tag_type))
  end
  
  def test_should_destroy_tag_type
    old_count = TagType.count
    delete :destroy, :id => 1
    assert_equal old_count-1, TagType.count
    
    assert_redirected_to tag_types_path
  end
end
