require File.dirname(__FILE__) + '/../test_helper'

class CommentsController
  def rescue_action(e) raise e end
  def protect_from_spam; end
end

class CommentsControllerTest < ActionController::TestCase

  def test_should_create_comment
    p = posts(:sample_post)
    assert_difference('p.comments.unmoderated.count') do
      post :create, p.permalink.merge(:comment => {:author => "Author", :body_raw => "A Comment."})
    end
    assert_redirected_to permalink_path(p.permalink)
  end
end
