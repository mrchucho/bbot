require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  def test_my_pages
    pages = Page.displayed_in_layout
    assert_equal 3, pages.size
    assert pages.detect{|page| page.title.downcase.eql?("about")}
    assert pages.detect{|page| page.title.downcase.eql?("contact")}
    assert pages.detect{|page| page.title.downcase.eql?("projects")}
  end

  def test_not_found_exception
    begin
      Page.find_by_title("not-a-real-page")
    rescue => e
      assert_instance_of ActiveRecord::RecordNotFound, e
      assert_equal "No such page.", e.message
    end
  end

  def test_content_with_attachment
    page = pages(:attachment_page)

    assert page.has_attachment?
    assert_equal({:file => "/pages/#{page.attachment}"}, page.content)
  end

  def test_content_with_missing_attachment
    page = pages(:projects)

    assert page.has_attachment?
    assert_equal({:text => "Content Missing"}, page.content)
  end

  def test_content_no_attachment
    page = pages(:about)

    assert !page.has_attachment?
    assert_equal({:inline => page.body}, page.content)
  end

  def test_permalink
    page = pages(:about)

    assert_equal({:id => page.title.downcase}, page.permalink)
  end
end
