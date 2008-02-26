class Post < ActiveRecord::Base
  has_many :comments
  before_save :convert_body
  before_save :create_slug
  attr_protected :body

  def Post.find_published(*args)
    with_scope(:find => {:conditions => {:published => true}}) do
      find(*args)
    end
  end

  def Post.per_page
    10
  end

  def Post.find_by_permalink(params)
    post = find(:all,:conditions => {:slug => params[:slug]})
    if post.size > 1
      begin
        date = Date.civil(params[:year].to_i,params[:month].to_i,params[:day].to_i)
        post.reject!{|p| p.created_at.to_date != date}
        raise ActiveRecord::RecordNotFound.new("No such post.") unless post.size == 1
      rescue => e
        logger.error("Error finding by permalink: #{e}")
        raise ActiveRecord::RecordNotFound.new("No such post.")
      end
    end
    post.pop
  end

  def permalink
    @permalink ||= {
      :year => sprintf("%4d",created_at.year),
      :month => sprintf("%02d",created_at.month),
      :day => sprintf("%02d",created_at.day),
      :slug => slug
    }
  end
private
  def convert_body
    self.body = RedCloth.new(self.body_raw).to_html
  end
  def create_slug
    self.slug = Post.escape(self.title)
  end
  def Post.escape(s)
    s.gsub(/[^(\w|\s)]+/,'').strip.gsub(/\s/,'-').downcase
  end
end
