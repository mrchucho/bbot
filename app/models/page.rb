class Page < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title

  def Page.find_by_title(title)
    unless page = Page.find(:first,:conditions => ["lower(title) = ?",title])
      raise ActiveRecord::RecordNotFound.new("No such page.")
    end
    page
  end

  def content
    unless has_attachment?
      {:inline => body}
    else
      {:file => "/pages/#{attachment}"}
    end
  end

  def has_attachment?
    !self.attachment.blank?
  end
end
