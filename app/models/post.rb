class Post < ActiveRecord::Base
  has_many :comments
  before_save :convert_body
  attr_protected :body

  def Post.published(*args)
    logger.debug "published"
    with_scope(:find => {:conditions => {:published => true}}) do
      find(*args)
    end
  end

private
  def convert_body
    self.body = RedCloth.new(self.body_raw).to_html
  end
end
