require File.dirname(__FILE__) + '/../test_helper'

class PostsController
  def rescue_action(e) raise e end
end

class PostsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  def test_should_get_new
    login_as(:quentin)
    get :new
    assert_response :success
  end

  def test_should_create_unpublished_post
    login_as(:quentin)
    assert_difference('Post.count') do
      post :create, :post => {:title => "title", :body_raw => "this _is_ the body", :published => false}
    end

    assert_redirected_to drafts_path
  end

  def test_should_create_published_post
    login_as(:quentin)
    assert_difference('Post.count') do
      post :create, :post => {:title => "title", :body_raw => "this _is_ the body", :published => true}
    end

    assert_redirected_to permalink_path(assigns(:post).permalink)
  end

  def test_should_show_post
    get :show, :id => posts(:sample_post).id
    assert_response :success
  end

  def test_should_get_edit
    login_as(:quentin)
    get :edit, :id => posts(:sample_post).id
    assert_response :success
  end

  def test_should_update_post
    login_as(:quentin)
    put :update, :id => posts(:sample_post).id, :post => { }
    assert_redirected_to permalink_path(assigns(:post).permalink)
  end

  def test_should_update_post_to_unpublished
    login_as(:quentin)
    put :update, :id => posts(:sample_post).id, :post => {:published => false }
    assert_redirected_to drafts_path
  end

  def test_should_destroy_post
    login_as(:quentin)
    assert_difference('Post.count', -1) do
      delete :destroy, :id => posts(:sample_post).id
    end

    assert_redirected_to posts_path
  end
end
