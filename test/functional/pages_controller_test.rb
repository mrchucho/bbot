require File.dirname(__FILE__) + '/../test_helper'

class PagesController
  def rescue_action(e) raise e end
end

class PagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  def test_should_get_new
    login_as(:quentin)
    get :new
    assert_response :success
  end

  def test_should_create_page
    login_as(:quentin)
    assert_difference('Page.count') do
      post :create, :page => {:title => "The Title"}
    end

    assert_redirected_to page_path(assigns(:page).permalink)
  end

  def test_should_show_page
    get :show, :id => pages(:about).title
    assert_response :success
  end

  def test_should_get_edit
    login_as(:quentin)
    get :edit, :id => pages(:about).title
    assert_response :success
  end

  def test_should_update_page
    login_as(:quentin)
    put :update, :id => pages(:about).title, :page => {:title => "New Title"}
    assert_redirected_to page_path(assigns(:page).permalink)
  end

  def test_should_destroy_page
    login_as(:quentin)
    assert_difference('Page.count', -1) do
      delete :destroy, :id => pages(:about).title
    end

    assert_redirected_to pages_path
  end
end
