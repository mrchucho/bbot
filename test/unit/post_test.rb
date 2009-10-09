require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

  def test_published
    p = Post.published.find(:all)
    assert !p.empty?
    assert !p.any?{|p| p.published == false}
  end

  def test_unpublished
    p = Post.unpublished.find(:all)
    assert !p.empty?
    assert !p.any?{|p| p.published == true}
  end

  def test_one_post_matching_permalink
    post = posts(:unique_slug)

    found = nil
    assert_nothing_thrown do
      found = Post.find_by_permalink(post.permalink)
    end
    assert_equal post.id,found.id
  end

  def test_two_posts_with_same_title_but_different_dates
    post = posts(:non_unique_slug_unique_date1)
    found = nil
    assert_nothing_thrown do
      found = Post.find_by_permalink(post.permalink)
    end
    assert_equal post.id,found.id
  end

  def test_two_posts_with_same_title_and_date
    post = posts(:non_unique_slug_non_unique_date1)
    found = nil
    assert_raises(ActiveRecord::RecordNotFound) do
      found = Post.find_by_permalink(post.permalink)
    end
    assert_equal nil, found
  end
end
