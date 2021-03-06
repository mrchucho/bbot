class Post < ActiveRecord::Base
  has_many :comments
  before_save :convert_body
  before_save :create_slug
  attr_protected :body

  validates_presence_of :title, :body_raw

  named_scope :published, :conditions => {:published => true}
  named_scope :unpublished, :conditions => {:published => false}
  named_scope :by_newest_first, :order => "created_at DESC"
  named_scope :by_oldest_first, :order => "created_at ASC"

  def Post.per_page
    10
  end

  def Post.find_by_permalink(params)
    post = find(:all,:conditions => {:slug => params[:slug]})
    if post.size > 1
      begin
        date = Date.civil(params[:year].to_i,params[:month].to_i,params[:day].to_i)
        post.reject!{|p| p.created_at.to_date != date}
      rescue => e
        raise ActiveRecord::RecordNotFound.new("No such post.")
      end
    end
    raise ActiveRecord::RecordNotFound.new("No such post.") unless post.size == 1
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
