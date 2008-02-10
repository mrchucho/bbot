module CommentsHelper
  def author(comment)
    comment.author_site.blank? ? h(comment.author) : link_to(h(comment.author), comment.author_site, :class => 'comment_author_site')
  end
end
