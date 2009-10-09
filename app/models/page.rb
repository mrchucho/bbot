class Page < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title

  def Page.find_by_title(title)
    unless page = Page.find(:first,:conditions => ["lower(title) = ?",title])
      raise ActiveRecord::RecordNotFound.new("No such page.")
    end
    page
  end

  def Page.displayed_in_layout
    Page.find(:all, :conditions => {:title => %w(about contact projects)}) # ,:conditions => {:display_in_layout => true})
  end

  def content
    unless has_attachment?
      {:inline => body}
    else
      if FileTest.exists?(File.join(Rails.root, "app", "views", "pages", attachment))
        {:file => "/pages/#{attachment}"}
      else
        {:text => "Content Missing"}
      end
    end
  end

  def has_attachment?
    !self.attachment.blank?
  end

  def permalink
    { :id => self.title.downcase }
  end
end
