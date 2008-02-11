class Comment < ActiveRecord::Base
  belongs_to :post
  before_save :convert_body
  attr_protected :post_id,:body
  validates_presence_of :author

  def Comment.moderated
    find(:all,:conditions => {:moderated => true })
  end

private
  def convert_body
    self.body = RedCloth.new(self.body_raw).to_html
  end
end
