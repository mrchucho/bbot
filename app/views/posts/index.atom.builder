atom_feed(:url => formatted_post_url(:atom)) do |feed|
feed.title("Posts")
=begin
feed.updated(@post.first ? @post.first.created_at : Time.now.utc)
=end

for post in @posts
  feed.entry(post) do |entry|
    entry.title(post.title)
    entry.content(post.body, :type => 'html')

=begin
    entry.author do |author|
      author.name(post.creator.name)
      author.email(post.creator.email_address)
    end
=end
  end
end
end
