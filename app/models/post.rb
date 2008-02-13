class Post < ActiveRecord::Base
  has_many :comments
  before_save :convert_body
  attr_protected :body

  def Post.find_published(*args)
    with_scope(:find => {:conditions => {:published => true}}) do
      find(*args)
    end
  end

  def Post.per_page
    10
  end
private
  def convert_body
    self.body = RedCloth.new(self.body_raw).to_html
  end
end
