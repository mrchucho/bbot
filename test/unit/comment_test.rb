require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  def test_moderated
    post = posts(:sample_post)
    assert post.comments.moderated.include?(comments(:sample_post_moderated_comment))
    assert !post.comments.moderated.any?{|c| c.moderated == false}
  end

  def test_unmoderated
    post = posts(:sample_post)
    assert post.comments.unmoderated.include?(comments(:sample_post_unmoderated_comment))
    assert !post.comments.unmoderated.any?{|c| c.moderated == true}
  end

  def test_moderated
    post = posts(:sample_post)
    comment = comments(:sample_post_unmoderated_comment)

    assert_equal false, comment.moderated?
    comment.moderate
    assert comment.moderated?
  end

  def test_moderation_increments_comment_counter
    post = posts(:sample_post)
    comment = comments(:sample_post_unmoderated_comment)

    before = post.moderated_comments_count
    comment.moderate
    post.reload
    assert_equal before + 1, post.moderated_comments_count
  end

  def test_destorying_comment_decrements_comment_counter
    post = posts(:sample_post)
    comment = comments(:sample_post_moderated_comment)

    before = post.moderated_comments_count
    comment.destroy
    post.reload
    assert_equal before - 1, post.moderated_comments_count
  end
end
