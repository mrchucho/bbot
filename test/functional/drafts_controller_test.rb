require File.dirname(__FILE__) + '/../test_helper'

class DraftsControllerTest < ActionController::TestCase

  def test_index
    login_as(:quentin)
    get :index
    assert_response :success
    assert_not_nil(assigns(:posts))
    assert !assigns(:posts).any?{|p| p.published?}
  end
end
