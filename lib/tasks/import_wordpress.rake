namespace :import do
  desc "Import from wordpress."
  task(:wordpress => :environment) do
    Post.establish_connection(:wordpress)
    wordpress_posts = Post.connection.execute("select post_title,post_date_gmt,post_modified_gmt,post_content from wp_posts where post_status = 'publish'")

    Post.establish_connection(:production)
    wordpress_posts.each do |wordpress_post|
      Post.create(:title => wordpress_post[0],
                  :created_at => wordpress_post[1],
                  :updated_at => wordpress_post[2],
                  :body_raw => wordpress_post[3].gsub(/[^<pre>]\n?<code>/,"<pre><code>").gsub(/<\/code>\n?[^<\/pre>]/,"</code></pre>").gsub("[source:ruby]","<pre>\n<code>").gsub("[/source]","</code>\n</pre>"),
                  :published => true
                 )
    end
  end
end
