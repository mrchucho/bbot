module ApplicationHelper
  def title(*args)
    content_for(:title) do
      (args.unshift 'watch this &amp;nbsp;').join(' &sect; ')
    end
  end

  def posted(post)
    post.created_at.strftime('%Y %b %d')
  end

  def posted_at(post)
    post.created_at.strftime('%Y %b %d at %H:%M')
  end

  def alt(index)
    index.even? ? "" : "alt"
  end
end
