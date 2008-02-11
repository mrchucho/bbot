class Comment < ActiveRecord::Base
  belongs_to :post
  before_save :convert_body
  attr_protected :post_id,:body
  validates_presence_of :author

  def Comment.moderated
    find(:all,:conditions => {:moderated => true })
  end

private
include ActionView::Helpers::TextHelper
  def convert_body
    self.body = textilize(self.body_raw)
  end
end
