class Comment < ActiveRecord::Base
  belongs_to :post
  # after_create :increment_moderated_comments_counter
  before_save :convert_body
  before_destroy :decrement_moderated_comments_counter

  attr_protected :post_id,:body,:moderated
  validates_presence_of :author

  def Comment.moderated
    find(:all,:conditions => {:moderated => true })
  end

  def Comment.find_unmoderated(*args)
    with_scope(:find => {:conditions => "moderated = 'f'"}) do
      find(*args)
    end
  end

  def moderate
    unless moderated?
      self.update_attribute("moderated",true)
      update_moderated_comment_count
    end
  end

private
  def convert_body
    self.body = RedCloth.new(self.body_raw,[:filter_html]).to_html
  end

  def update_moderated_comment_count(inc = 1)
    if (new_count = self.post.moderated_comments_count + inc) >= 0
      self.post.update_attribute("moderated_comments_count",new_count)
    end
  end
  def increment_moderated_comments_counter
    # Post.increment_count(:moderated_comments_count,self.post_id) if moderated
    update_moderated_comment_count if moderated
  end
  def decrement_moderated_comments_counter
    # Post.decrement_count(:moderated_comments_count,self.post_id) if moderated
    update_moderated_comment_count(-1) if moderated?
  end
end
