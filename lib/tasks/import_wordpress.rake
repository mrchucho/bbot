namespace :import do
  desc "Import from wordpress."
  task(:wordpress => :environment) do
    Post.establish_connection(:wordpress)
    wordpress_posts = Post.connection.execute("select post_title,post_date_gmt,post_modified_gmt,post_content from wp_posts where post_status = 'publish'")
    wordpress_comments = Post.connection.execute("select comment_author,comment_author_email,comment_author_url,comment_date_gmt,comment_content,post_title from wp_comments, wp_posts where comment_post_ID = ID and comment_approved = '1'")

    Post.establish_connection(RAILS_ENV)
    wordpress_posts.each do |wordpress_post|
      Post.create(:title => wordpress_post[0],
                  :created_at => wordpress_post[1],
                  :updated_at => wordpress_post[2],
                  :body_raw => wordpress_post[3].gsub(/[^<pre>]\n?<code>/,"<pre><code>").gsub(/<\/code>\n?[^<\/pre>]/,"</code></pre>").gsub("[source:ruby]","<pre>\n<code>").gsub("[/source]","</code>\n</pre>"),
                  :published => true
                 )
    end
    wordpress_comments.each do |wordpress_comment|
      comment = Post.find_by_title(wordpress_comment.last).comments.create(:author => wordpress_comment[0],
                                                                           :author_email => wordpress_comment[1],
                                                                           :author_site =>wordpress_comment[2],
                                                                           :body_raw => wordpress_comment[4],
                                                                           :created_at =>wordpress_comment[3])
      comment.moderate
    end
  end

  desc "Update content links."
  task(:content => :environment) do
    Post.find(:all).each do |post|
      post.body_raw.gsub!("http://www.mrchucho.net/wordpress/wp-content","/content")
      post.body_raw.gsub!("http://www.mrchucho.net/downloads","/downloads")
      post.save
    end
  end
end
