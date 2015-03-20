xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = "http://blog.og.nr/"
  xml.title "The Blog of On The Ground News Reports (OGNR)"
  xml.subtitle "A Behind The Scenes Look At Breaking News"
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name "On The Ground News Reports - OGNR" }

  blog.articles[0..5].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name article.data.author unless article.data.author.empty? }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
