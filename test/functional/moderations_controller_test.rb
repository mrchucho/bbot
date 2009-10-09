require File.dirname(__FILE__) + '/../test_helper'

class ModerationsController
  def rescue_action(e) raise e end
end

class ModerationsControllerTest < ActionController::TestCase

  def setup
    login_as(:quentin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
    assert !assigns(:comments).any?{|c| c.moderated?}
  end

  def test_should_show_moderation_for_unmoderated_comment
    get :show, {:id => comments(:sample_post_unmoderated_comment).id}
    assert_response :success
    assert_not_nil assigns(:comment)
  end

  def test_should_show_moderation_for_moderated_comment
    assert_raise(ActiveRecord::RecordNotFound) do
      get :show, {:id => comments(:sample_post_moderated_comment).id}
    end
    # assert_response :not_found # maybe this only works in production?
    assert_nil assigns(:comment)
  end

  def test_should_update_moderation
    p = posts(:sample_post)
    comment = p.comments.unmoderated.first
    assert_difference('p.comments.unmoderated.count', -1) do
      put :update, :id => comment.id
    end
    assert_redirected_to moderations_url
    assert /^Moderated comment by <em>#{comment.author}/.match(flash[:notice])
  end

  def test_should_destroy_moderation
    p = posts(:sample_post)
    comment = p.comments.unmoderated.first
    assert_difference('p.comments.count', -1) do
      delete :destroy, :id => comment.id
    end
    assert_redirected_to moderations_url
    assert /^Deleted comment by <em>#{comment.author}/.match(flash[:notice])
  end
end
