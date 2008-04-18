atom_feed(:schema_date => "2008") do |feed|
    # id ?
    feed.title("watch this &amp;nbsp;", :type => 'html')
    # feed.description("The Official MrChucho Blog")
    feed.updated(@posts.first ? @posts.first.created_at : Time.now.utc)

    for post in @posts
      feed.entry(post,:url => permalink_url(post.permalink)) do |entry|
        # id
        entry.title(post.title)
        entry.content(post.body, :type => 'html')

        entry.author do |author|
          author.name("mrchucho")
          # author.email("mrchucho@mrchucho.net")
        end
      end
    end
end
