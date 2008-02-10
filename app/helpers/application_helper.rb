module ApplicationHelper
  def title(*args)
    # &brvbar &raquo &sect
    (args.unshift 'watch this &amp;nbsp;').join(' &sect; ')
  end

  def posted(post)
    post.created_at.strftime('%Y %b %d')
  end

  def posted_at(post)
    post.created_at.strftime('%Y %b %d at %H:%M')
  end
end
