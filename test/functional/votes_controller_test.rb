require File.dirname(__FILE__) + '/../test_helper'
require 'votes_controller'
#require File.dirname(__FILE__) + '/users_controller_test' 

# Re-raise errors caught by the controller.
class VotesController; def rescue_action(e) raise e end; end

class VotesControllerTest < Test::Unit::TestCase
  fixtures :votes
  fixtures :users

  def setup
    @controller = VotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # there's a bug in the TestSession class, :user isn't found
    # @session	= { :user => users(:admin), 'user' => users(:admin) }
    @session	= Test::Unit::TestCase.logged_in_session
  end

  def test_should_get_index
    pp @session
    Kernel.exit

    get :index, {}, @session
    assert_response :success
    assert assigns(:votes)
  end

  def test_should_get_new
    get :new, {}, @session
    assert_response :success
  end
  
  def test_should_create_vote
    old_count = Vote.count
    post :create, { :vote => { :name => 'Ignore', :value => -12345 } }, @session
    assert_equal old_count+1, Vote.count
    
    assert_redirected_to vote_path(assigns(:vote))
  end

  def test_should_show_vote
    get :show, { :id => votes(:veto).id }, @session
    assert_response :success
  end

  def test_should_get_edit
    get :edit, { :id => votes(:veto).id }, @session
    assert_response :success
  end
  
  def test_should_update_vote
    put :update, { :id => votes(:veto).id, :vote => { } }, @session
    assert_redirected_to vote_path(assigns(:vote))
  end
  
  def test_should_destroy_vote
    old_count = Vote.count
    delete :destroy, { :id => votes(:veto).id }, @session
    assert_equal old_count-1, Vote.count
    
    assert_redirected_to votes_path
  end
end
