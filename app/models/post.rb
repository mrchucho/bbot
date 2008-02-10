class Post < ActiveRecord::Base
  has_many :comments
  before_save :convert_body
  attr_protected :body

  def comments_count
    @comments_count ||= comments.count
  end

private
include ActionView::Helpers::TextHelper
  def convert_body
    self.body = textilize(self.body_raw)
  end
end
