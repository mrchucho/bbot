atom_feed(:schema_date => "2008") do |feed|
    # id ?
    feed.title(BLOG_TITLE, :type => 'html')
    # feed.description(BLOG_SUBTITLE)
    feed.updated(@posts.first ? @posts.first.created_at : Time.now.utc)

    for post in @posts
      feed.entry(post,:url => permalink_url(post.permalink)) do |entry|
        # id
        entry.title(post.title)
        entry.content(post.body, :type => 'html')

        entry.author do |author|
          author.name(BLOG_AUTHOR)
        end
      end
    end
end
