xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title BLOG_TITLE
    xml.description BLOG_SUBTITLE
    xml.link formatted_posts_url(:rss)

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.body
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link permalink_url(post.permalink)
        xml.guid permalink_url(post.permalink)
      end
    end
  end
end


